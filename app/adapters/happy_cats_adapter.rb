# frozen_string_literal: true

class HappyCatsAdapter < ApplicationAdapter
  MAPPING = {
    title: :breed,
    cost: :price,
    location: :location,
    img: :image
  }.with_indifferent_access.freeze

  def all
    return [] unless object.success?

    object.parsed_response['cats']['cat'].map do |attributes|
      Cat.new(attributes.transform_keys { |key| MAPPING[key] || key })
    end
  end
end
