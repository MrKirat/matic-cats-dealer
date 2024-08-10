# frozen_string_literal: true

class CatsUnlimitedAdapter < ApplicationAdapter
  def all
    return [] unless object.success?

    object.parsed_response
  end
end
