# frozen_string_literal: true

module Cats
  # ListOperation is an operation that filters and sorts a list of cats based on
  # provided criteria. It inherits from `ApplicationOperation` and leverages
  # Dry-Validation contracts to validate input parameters.
  #
  # This operation supports filtering cats by `location` and `breed`, as well as
  # sorting the results by price, either cheapest first or most expensive first.
  #
  # The operation follows a series of steps:
  # 1. Filters the list of cats by location, if provided.
  # 2. Filters the list of cats by breed, if provided.
  # 3. Sorts the list of cats by price, if a sort order is specified.
  #
  class ListOperation < ::ApplicationOperation
    # Constants representing sorting orders.
    CHEAP_FIRST = 'cheap_first'
    EXPENSIVE_FIRST = 'expensive_first'

    # Defines the validation contract for the operation.
    # The contract checks for optional parameters:
    #   - `location`: a string representing the location to filter by.
    #   - `breed`: a string representing the breed to filter by.
    #   - `sort`: a string that must match one of the sorting constants.
    contract do
      params do
        optional(:location).filled(:string)
        optional(:breed).filled(:string)
        optional(:sort).value(T::String.enum(CHEAP_FIRST, EXPENSIVE_FIRST))
      end
    end

    # Executes the operation, filtering and sorting cats based on the input context.
    #
    # @return [Dry::Monads::Result::Success] with the filtered and sorted list of cats.
    def call
      cats = filter_by(:location, all_cats)
      cats = filter_by(:breed, cats)
      cats = sort_by_price(cats)
      Success(cats)
    end

    private

    # Filters the list of cats by a specific attribute (key).
    #
    # @param key [Symbol] The attribute to filter by (e.g., :location, :breed).
    # @param cats [Array<Cat>] The list of cats to filter.
    # @return [Array<Cat>] The filtered list of cats.
    def filter_by(key, cats)
      return cats if ctx[key].blank?

      cats.filter { |cat| cat.public_send(key) == ctx[key] }
    end

    # Sorts the list of cats by price based on the sort order in the context.
    #
    # @param cats [Array<Cat>] The list of cats to sort.
    # @return [Array<Cat>] The sorted list of cats.
    def sort_by_price(cats)
      return cats.sort_by(&:price)         if cheap_first?
      return cats.sort_by(&:price).reverse if expensive_first?

      cats
    end

    # Checks if the sort order is set to `cheap_first`.
    #
    # @return [Boolean] True if the sort order is `cheap_first`, otherwise false.
    def cheap_first?
      ctx[:sort].present? && ctx[:sort] == CHEAP_FIRST
    end

    # Checks if the sort order is set to `expensive_first`.
    #
    # @return [Boolean] True if the sort order is `expensive_first`, otherwise false.
    def expensive_first?
      ctx[:sort].present? && ctx[:sort] == EXPENSIVE_FIRST
    end

    # Retrieves all cats from the repository.
    #
    # @return [Array<Cat>] The complete list of cats.
    def all_cats
      ::CatRepository.all
    end
  end
end
