# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatRepository do
  let(:lviv_expensive_cat)    { build(:cat, :expensive, :lviv) }
  let(:lviv_cheap_cat)        { build(:cat, :cheap,     :lviv) }
  let(:kharkiv_expensive_cat) { build(:cat, :expensive, :kharkiv) }
  let(:kharkiv_cheap_cat)     { build(:cat, :cheap,     :kharkiv) }

  let(:cats_unlimited_adapter) { instance_double(CatsUnlimitedAdapter, all: [lviv_expensive_cat, kharkiv_cheap_cat]) }
  let(:happy_cats_adapter)     { instance_double(HappyCatsAdapter,     all: [lviv_cheap_cat, kharkiv_expensive_cat]) }

  let(:cats_unlimited_response) { instance_double(HTTParty::Response) }
  let(:happy_cats_response)     { instance_double(HTTParty::Response) }

  before do
    allow(CatClient).to receive_messages(cats_unlimited: cats_unlimited_response, happy_cats: happy_cats_response)
    allow(CatsUnlimitedAdapter).to receive(:new).with(cats_unlimited_response).and_return(cats_unlimited_adapter)
    allow(HappyCatsAdapter).to receive(:new).with(happy_cats_response).and_return(happy_cats_adapter)
  end

  describe '.all' do
    subject(:response) { described_class.all }

    let(:expected_cats) { [lviv_expensive_cat, lviv_cheap_cat, kharkiv_expensive_cat, kharkiv_cheap_cat] }

    it { is_expected.to match_array(expected_cats) }
  end

  describe '.cheapest_by_location' do
    subject(:response) { described_class.cheapest_by_location(location) }

    context 'when location is Lviv' do
      let(:location) { 'Lviv' }

      it { is_expected.to eq lviv_cheap_cat }
    end

    context 'when location is Kharkiv' do
      let(:location) { 'Kharkiv' }

      it { is_expected.to eq kharkiv_cheap_cat }
    end
  end
end
