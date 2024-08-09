# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatsClient do
  describe '.cats_unlimited' do
    subject(:response) { described_class.cats_unlimited }

    context 'with successfull response', vcr: { cassette_name: 'cats/cats_unlimited' } do
      it 'returns cats' do
        expect(response).to be_ok
        expect(response).to all(include('name', 'price', 'location', 'image'))
      end
    end

    context 'with error response', vcr: { cassette_name: 'cats/cats_unlimited_error' } do
      it 'returns error' do
        expect(response).to be_server_error
      end
    end
  end

  describe '.happy_cats' do
    subject(:response) { described_class.happy_cats }

    context 'with successfull response', vcr: { cassette_name: 'cats/happy_cats' } do
      it 'returns cats' do
        expect(response).to be_ok
        expect(response['cats']['cat']).to all(include('title', 'cost', 'location', 'img'))
      end
    end

    context 'with error response', vcr: { cassette_name: 'cats/happy_cats_error' } do
      it 'returns error' do
        expect(response).to be_server_error
      end
    end
  end
end
