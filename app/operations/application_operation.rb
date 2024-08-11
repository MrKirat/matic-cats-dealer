# frozen_string_literal: true

class ApplicationOperation
  extend ::Dry::Monads[:result]
  include ::Dry::Monads[:result]

  module T
    include ::Dry.Types
  end

  CONTRACT_KLASS = 'Contract'

  class << self
    def call(ctx = {})
      ctx = parse_context(ctx)

      new(ctx).call unless contract_klass_defined?

      contract_klass.new.call(ctx).then do |validation|
        return Failure[:unprocessable_entity, validation.errors.to_h] if validation.failure?

        new(ctx).call
      end
    end

    private

    def parse_context(ctx)
      return ctx.with_indifferent_access if ctx.respond_to?(:with_indifferent_access)
      return ctx.to_unsafe_h if ctx.respond_to?(:to_unsafe_h)

      ctx
    end

    def contract(&)
      set_contract_klass(&) unless contract_klass_defined?
    end

    def contract_klass_defined?
      const_defined?(CONTRACT_KLASS)
    end

    def contract_klass
      const_get(CONTRACT_KLASS)
    end

    def set_contract_klass(&)
      const_set(CONTRACT_KLASS, Class.new(::Dry::Validation::Contract, &))
    end
  end

  private

  attr_reader :ctx

  def initialize(ctx)
    @ctx = ctx
  end

  def call
    raise NoMethodError, 'this method should be implemented in child'
  end
end
