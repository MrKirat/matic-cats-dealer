# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cat do
  describe '.new' do
    subject { described_class.new(attributes) }

    let(:attributes) { { name:, price:, location:, image: } }
    let(:name) { 'name' }
    let(:price) { '100' }
    let(:location) { 'location' }
    let(:image) { 'image' }

    it { is_expected.to have_attributes(name:, price: price.to_i, location:, image:) }
  end
end
