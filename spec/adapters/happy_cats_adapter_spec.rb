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
          'cats' => { 'cat' => [first_cat, second_cat] }
        }
      end

      let(:first_cat) do
        { 'title' => 'title_1', 'cost' => '100', 'location' => 'location_1', 'img' => 'img_1' }
      end

      let(:second_cat) do
        { 'title' => 'title_2', 'cost' => '200', 'location' => 'location_2', 'img' => 'img_2' }
      end

      let(:expected_cats) do
        [
          {
            name: first_cat['title'], price: first_cat['cost'],
            location: first_cat['location'], image: first_cat['img']
          },
          {
            name: second_cat['title'], price: second_cat['cost'],
            location: second_cat['location'], image: second_cat['img']
          }
        ]
      end

      it { is_expected.to contain_exactly(expected_cats) }
    end
  end
end
