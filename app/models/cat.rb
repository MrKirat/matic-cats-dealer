# frozen_string_literal: true

# Cat represents a cat entity in the application. It is an ActiveModel-based
# model, which means it includes features similar to ActiveRecord models, such
# as attributes and validations, without being tied to a database.
#
# The `Cat` model is used to represent the data of a cat, including its breed,
# price, location, and image.
#
class Cat
  include ActiveModel::Model
  include ActiveModel::Attributes

  # @!attribute [rw] breed
  #   @return [String] The breed of the cat.
  attribute :breed, :string

  # @!attribute [rw] price
  #   @return [Integer] The price of the cat.
  attribute :price, :integer

  # @!attribute [rw] location
  #   @return [String] The location where the cat is available.
  attribute :location, :string

  # @!attribute [rw] image
  #   @return [String] A URL to an image of the cat.
  attribute :image, :string
end
