# frozen_string_literal: true

# CatBlueprint defines the JSON serialization format for `Cat` objects.
# It specifies the fields `breed`, `price`, `location`, and `image` to be included in the JSON output.
#
# @see https://github.com/procore/blueprinter Blueprinter Documentation
class CatBlueprint < ApplicationBlueprint
  fields :breed, :price, :location, :image
end
