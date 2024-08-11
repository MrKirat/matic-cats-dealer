# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatBlueprint do
  describe '.render' do
    subject(:render) { described_class.render(object) }

    let(:parsed_object) { JSON.parse(render, symbolize_names: true) }

    context 'with single cat' do
      let(:object) { build(:cat) }

      it 'serializes cat' do
        expect(parsed_object).to match(
          breed: object.breed, price: object.price, location: object.location, image: object.image
        )
      end
    end

    context 'with multiple cats' do
      let(:object) { build_list(:cat, 2) }

      let(:first_cat) { object[0] }
      let(:second_cat) { object[1] }

      let(:parsed_first_cat) do
        { breed: first_cat.breed, price: first_cat.price, location: first_cat.location, image: first_cat.image }
      end

      let(:parsed_second_cat) do
        { breed: second_cat.breed, price: second_cat.price, location: second_cat.location, image: second_cat.image }
      end

      it 'serializes cats' do
        expect(parsed_object).to contain_exactly(
          match(parsed_first_cat), match(parsed_second_cat)
        )
      end
    end
  end
end
