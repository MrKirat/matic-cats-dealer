# frozen_string_literal: true

# ApplicationOperation is a base class for all operation classes in the application.
# It provides a framework for defining and executing business logic in a structured way,
# using Dry-Monads for result handling and Dry-Validation for input validation.
#
# The core functionality includes:
# 1. Handling the initialization of an operation with a given context.
# 2. Providing a contract mechanism for input validation.
# 3. Managing the flow of the operation, returning either a `Success` or `Failure` result.
#
# @see https://dry-rb.org/gems/dry-validation/1.10/ Dry-Validation Documentation
# @see https://dry-rb.org/gems/dry-monads/1.6/ Dry-Monads Documentation
# @see https://dry-rb.org/gems/dry-types/1.7/ Dry-Types Documentation
class ApplicationOperation
  extend ::Dry::Monads[:result]
  include ::Dry::Monads[:result]

  # Module T is a namespace that includes Dry-Types.
  # It is used to define strict types for contract validations within operations.
  #
  # For example, T::String or T::Integer can be used to enforce type constraints
  # in the validation contract, ensuring that input data conforms to expected types.
  #
  # @see https://dry-rb.org/gems/dry-types/1.7/ Dry-Types Documentation
  module T
    include ::Dry.Types
  end

  CONTRACT_KLASS = 'Contract'

  class << self
    # Executes the operation with the given context, handling validation
    # and invoking the operation's logic.
    #
    # @param ctx [Hash, ActionController::Parameters, HashWithIndifferentAccess] The input context for the operation.
    # @return [Dry::Monads::Result::Success, Dry::Monads::Result::Failure] The result of the operation,
    #   either success or failure.
    #
    # @see https://dry-rb.org/gems/dry-monads/1.6/ Dry-Monads Documentation
    def call(ctx = {})
      ctx = parse_context(ctx)

      return new(ctx).call unless contract_klass_defined?

      contract_klass.new.call(ctx).then do |validation|
        return Failure[:unprocessable_entity, validation.errors.to_h] if validation.failure?

        new(ctx).call
      end
    end

    private

    # Converts the context to a standard format, ensuring it can be processed uniformly.
    #
    # @param ctx [Object] The context object to be parsed.
    # @return [HashWithIndifferentAccess] The parsed context, converted to a hash with indifferent access.
    def parse_context(ctx)
      return ctx.with_indifferent_access if ctx.respond_to?(:with_indifferent_access)
      return ctx.to_unsafe_h if ctx.respond_to?(:to_unsafe_h)

      ctx
    end

    # Defines a validation contract for the operation.
    #
    # The contract ensures that the input context meets the necessary criteria
    # before the operation is executed. This helps in maintaining data integrity
    # and reducing errors in the operation flow.
    #
    # The contract is only set once per operation class.
    #
    # @yield The block defining the contract.
    #
    # @see https://dry-rb.org/gems/dry-validation/1.10/ Dry-Validation Documentation
    def contract(&)
      set_contract_klass(&) unless contract_klass_defined?
    end

    # Checks if a contract class has already been defined for the operation.
    #
    # @return [Boolean] True if the contract class is defined, otherwise false.
    def contract_klass_defined?
      const_defined?(CONTRACT_KLASS)
    end

    # Retrieves the contract class for the operation.
    #
    # @return [Class] The contract class.
    def contract_klass
      const_get(CONTRACT_KLASS)
    end

    # Sets the contract class for the operation using the provided block.
    #
    # The contract class is dynamically created as a subclass of `Dry::Validation::Contract`
    # and is only defined once, ensuring that the contract logic is consistent across
    # all instances of the operation.
    #
    # @param block [Proc] The block defining the contract.
    def set_contract_klass(&)
      const_set(CONTRACT_KLASS, Class.new(::Dry::Validation::Contract, &))
    end
  end

  private

  attr_reader :ctx

  # Initializes the operation with the given context.
  #
  # @param ctx [HashWithIndifferentAccess] The input context for the operation.
  def initialize(ctx)
    @ctx = ctx
  end

  # Executes the operation's business logic.
  #
  # This method must be implemented by subclasses.
  #
  # @raise [NoMethodError] if not implemented in a subclass.
  def call
    raise NoMethodError, 'this method should be implemented in child'
  end
end
