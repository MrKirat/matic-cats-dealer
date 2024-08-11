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
      new(ctx).call unless contract_klass_defined?

      contract_klass.new.call(ctx).then do |validation|
        return Failure[:invalid_params, validation.errors.to_h] if validation.failure?

        new(ctx).call
      end
    end

    private

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
    @ctx = ctx.with_indifferent_access
  end

  def call
    raise NoMethodError, 'this method should be implemented in child'
  end
end
