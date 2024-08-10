# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cat do
  describe '.new' do
    subject { described_class.new(attributes) }

    let(:attributes) { { breed:, price:, location:, image: } }
    let(:breed) { Faker::Creature::Cat.breed }
    let(:price) { '200' }
    let(:location) { Faker::Address.city }
    let(:image) { Faker::LoremFlickr.image }

    it { is_expected.to have_attributes(breed:, price: price.to_i, location:, image:) }
  end
end
