# frozen_string_literal: true

class HappyCatsAdapter < ApplicationAdapter
  MAPPING = {
    title: :name,
    cost: :price,
    location: :location,
    img: :image
  }.with_indifferent_access.freeze

  def all
    return [] unless object.success?

    cats.map do |cat|
      cat.transform_keys { |key| MAPPING[key] }
    end
  end

  private

  def cats = object.parsed_response['cats']['cat']
end
