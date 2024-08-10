# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cat do
  describe '.new' do
    subject { described_class.new(attributes) }

    let(:attributes) { { breed:, price:, location:, image: } }
    let(:breed) { 'breed' }
    let(:price) { '100' }
    let(:location) { 'location' }
    let(:image) { 'image' }

    it { is_expected.to have_attributes(breed:, price: price.to_i, location:, image:) }
  end
end
