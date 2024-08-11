# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cats::ListOperation do
  describe '.call' do
    subject(:call) { described_class.call(params) }

    include_context 'with diverse cats'

    before { allow(CatRepository).to receive(:all).and_return(diverse_cats) }

    context 'without params' do
      subject(:call) { described_class.call }

      it 'returns all cats' do
        expect(call).to be_success_monad diverse_cats
      end
    end

    context 'with location param' do
      let(:params) { { location: 'Lviv' } }

      it 'returns cats from specified location' do
        expect(call).to be_success_monad contain_exactly(lviv_cheapest_cat, lviv_pricy_cat)
      end
    end

    context 'with empty location' do
      let(:params) { { location: '' } }

      it 'return location failure' do
        expect(call).to be_failure_monad [:invalid_params, { location: ['must be filled'] }]
      end
    end

    context 'with breed param' do
      let(:params) { { breed: lviv_cheapest_cat.breed } }

      it 'returns cats with specified breed' do
        expect(call).to be_success_monad [lviv_cheapest_cat]
      end
    end

    context 'with empty breed' do
      let(:params) { { breed: '' } }

      it 'returns breed failure' do
        expect(call).to be_failure_monad [:invalid_params, { breed: ['must be filled'] }]
      end
    end

    context 'when sorted from cheapest to most expensive' do
      let(:params) { { sort: 'cheap_first' } }

      it 'returns cheap cats first' do
        expect(call).to be_success_monad [lviv_cheapest_cat, kharkiv_cheap_cat, lviv_pricy_cat, kharkiv_priciest_cat]
      end
    end

    context 'when sorted from most expensive to cheapest' do
      let(:params) { { sort: 'expensive_first' } }

      it 'returns expensive cats first' do
        expect(call).to be_success_monad [kharkiv_priciest_cat, lviv_pricy_cat, kharkiv_cheap_cat, lviv_cheapest_cat]
      end
    end

    context 'when sorted by incorrect value' do
      let(:params) { { sort: 'incorrect_sorting_value' } }

      it 'returns breed failure' do
        expect(call).to be_failure_monad [:invalid_params, { sort: ['must be one of: cheap_first, expensive_first'] }]
      end
    end

    context 'with empty sort' do
      let(:params) { { sort: '' } }

      it 'returns breed failure' do
        expect(call).to be_failure_monad [:invalid_params, { sort: ['must be one of: cheap_first, expensive_first'] }]
      end
    end
  end
end
