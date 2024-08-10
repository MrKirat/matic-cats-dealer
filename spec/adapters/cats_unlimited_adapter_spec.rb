# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatsUnlimitedAdapter do
  let(:adapter) { described_class.new(response) }

  describe '.all' do
    subject { adapter.all }

    context 'when response is unsuccessful' do
      let(:response) { instance_double(HTTParty::Response, success?: false) }

      it { is_expected.to be_empty }
    end

    context 'when response is successful' do
      let(:response) { instance_double(HTTParty::Response, success?: true, parsed_response: raw_cats) }
      let(:raw_cats) { [first_cat_attributes, second_cat_attributes] }

      let(:first_cat_attributes) do
        {
          'name' => Faker::Creature::Cat.breed, 'price' => '100',
          'location' => Faker::Address.city, 'image' => Faker::LoremFlickr.image
        }
      end

      let(:second_cat_attributes) do
        {
          'name' => Faker::Creature::Cat.breed, 'price' => '200',
          'location' => Faker::Address.city, 'image' => Faker::LoremFlickr.image
        }
      end

      let(:expected_first_cat) do
        have_attributes(
          breed: first_cat_attributes['name'], price: first_cat_attributes['price'].to_i,
          location: first_cat_attributes['location'], image: first_cat_attributes['image']
        )
      end

      let(:expected_second_cat) do
        have_attributes(
          breed: second_cat_attributes['name'], price: second_cat_attributes['price'].to_i,
          location: second_cat_attributes['location'], image: second_cat_attributes['image']
        )
      end

      it { is_expected.to contain_exactly(expected_first_cat, expected_second_cat) }
    end
  end
end
