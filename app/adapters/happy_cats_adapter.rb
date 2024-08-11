# frozen_string_literal: true

# HappyCatsAdapter is responsible for adapting data fetched by
# `CatClient` from the `happy_cats` endpoint.
#
# It transforms the raw data into a format suitable for creating
# `Cat` objects. The adapter maps multiple attributes from the
# response to the corresponding attributes in the `Cat` model.
#
class HappyCatsAdapter < ApplicationAdapter
  # A mapping of attributes from the source data to the `Cat` model
  # attributes. This includes mapping `title` to `breed`, `cost` to `price`,
  # and others.
  #
  # @return [HashWithIndifferentAccess] The attribute mapping.
  MAPPING = {
    title: :breed,
    cost: :price,
    location: :location,
    img: :image
  }.with_indifferent_access.freeze

  # Returns all cats from the adapted data.
  #
  # This method checks if the fetched data was successful. If successful,
  # it maps each set of attributes from the response to a `Cat` object,
  # applying the attribute mapping defined in `MAPPING`. Else it returns empty array.
  #
  # @return [Array<Cat>] An array of `Cat` objects created from the adapted data.
  def all
    return [] unless object.success?

    object.parsed_response['cats']['cat'].map do |attributes|
      Cat.new(attributes.transform_keys { |key| MAPPING[key] || key })
    end
  end
end
