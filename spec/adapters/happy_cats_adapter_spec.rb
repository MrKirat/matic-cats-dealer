# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HappyCatsAdapter do
  let(:adapter) { described_class.new(response) }

  describe '.all' do
    subject(:all) { adapter.all }

    context 'when response is unsuccessful' do
      let(:response) { instance_double(HTTParty::Response, success?: false) }

      it { is_expected.to be_empty }
    end

    context 'when response is successful' do
      let(:response) { instance_double(HTTParty::Response, success?: true, parsed_response: raw_cats) }
      let(:raw_cats) do
        {
          'cats' => { 'cat' => [first_cat_attributes, second_cat_attributes] }
        }
      end

      let(:first_cat_attributes) do
        {
          'title' => Faker::Creature::Cat.breed, 'cost' => '100',
          'location' => Faker::Address.city, 'img' => Faker::LoremFlickr.image
        }
      end

      let(:second_cat_attributes) do
        {
          'title' => Faker::Creature::Cat.breed, 'cost' => '200',
          'location' => Faker::Address.city, 'img' => Faker::LoremFlickr.image
        }
      end

      let(:expected_first_cat) do
        have_attributes(
          breed: first_cat_attributes['title'], price: first_cat_attributes['cost'].to_i,
          location: first_cat_attributes['location'], image: first_cat_attributes['img']
        )
      end

      let(:expected_second_cat) do
        have_attributes(
          breed: second_cat_attributes['title'], price: second_cat_attributes['cost'].to_i,
          location: second_cat_attributes['location'], image: second_cat_attributes['img']
        )
      end

      it { is_expected.to contain_exactly(expected_first_cat, expected_second_cat) }
    end
  end
end
