# frozen_string_literal: true

# CatsUnlimitedAdapter is responsible for adapting data fetched by
# `CatClient` from the `cats_unlimited` endpoint.
#
# It transforms the raw data into a format suitable for creating `Cat`
# objects. Specifically, it maps the `name` attribute from the response
# to the `breed` attribute of the `Cat` model.
#
class CatsUnlimitedAdapter < ApplicationAdapter
  # A mapping of attributes from the source data to the `Cat` model attributes.
  # Currently, it only maps `name` to `breed`.
  #
  # @return [HashWithIndifferentAccess] The attribute mapping.
  MAPPING = { name: :breed }.with_indifferent_access.freeze

  # Returns all cats from the adapted data.
  #
  # This method checks if the fetched data was successful. If successful,
  # it maps each set of attributes from the response to a `Cat` object,
  # applying the attribute mapping defined in `MAPPING`. Else it returns empty array.
  #
  # @return [Array<Cat>] An array of `Cat` objects created from the adapted data.
  def all
    return [] unless object.success?

    object.parsed_response.map do |attributes|
      Cat.new(attributes.transform_keys { |key| MAPPING[key] || key })
    end
  end
end
