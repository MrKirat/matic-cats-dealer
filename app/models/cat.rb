# frozen_string_literal: true

class Cat
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :price, :integer
  attribute :location, :string
  attribute :image, :string
end
