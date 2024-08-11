# frozen_string_literal: true

module Cats
  class ListOperation < ::ApplicationOperation
    CHEAP_FIRST = 'cheap_first'
    EXPENSIVE_FIRST = 'expensive_first'

    contract do
      params do
        optional(:location).filled(:string)
        optional(:breed).filled(:string)
        optional(:sort).value(T::String.enum(CHEAP_FIRST, EXPENSIVE_FIRST))
      end
    end

    def call
      cats = filter_by(:location, all_cats)
      cats = filter_by(:breed, cats)
      cats = sort_by_price(cats)
      Success(cats)
    end

    private

    def filter_by(key, cats)
      return cats if ctx[key].blank?

      cats.filter { |cat| cat.public_send(key) == ctx[key] }
    end

    def sort_by_price(cats)
      return cats.sort_by(&:price)         if cheap_first?
      return cats.sort_by(&:price).reverse if expensive_first?

      cats
    end

    def cheap_first?
      ctx[:sort].present? && ctx[:sort] == CHEAP_FIRST
    end

    def expensive_first?
      ctx[:sort].present? && ctx[:sort] == EXPENSIVE_FIRST
    end

    def all_cats
      ::CatRepository.all
    end
  end
end
