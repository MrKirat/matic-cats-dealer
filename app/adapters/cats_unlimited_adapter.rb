# frozen_string_literal: true

class CatsUnlimitedAdapter < ApplicationAdapter
  MAPPING = { name: :breed }.with_indifferent_access.freeze

  def all
    return [] unless object.success?

    object.parsed_response.map do |attributes|
      Cat.new(attributes.transform_keys { |key| MAPPING[key] || key })
    end
  end
end
