# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatRepository do
  include_context 'with diverse cats'

  let(:cats_unlimited_adapter) { instance_double(CatsUnlimitedAdapter, all: [lviv_pricy_cat, kharkiv_cheap_cat]) }
  let(:happy_cats_adapter)     { instance_double(HappyCatsAdapter,     all: [lviv_cheapest_cat, kharkiv_priciest_cat]) }

  let(:cats_unlimited_response) { instance_double(HTTParty::Response) }
  let(:happy_cats_response)     { instance_double(HTTParty::Response) }

  before do
    allow(CatClient).to receive_messages(cats_unlimited: cats_unlimited_response, happy_cats: happy_cats_response)
    allow(CatsUnlimitedAdapter).to receive(:new).with(cats_unlimited_response).and_return(cats_unlimited_adapter)
    allow(HappyCatsAdapter).to receive(:new).with(happy_cats_response).and_return(happy_cats_adapter)
  end

  describe '.all' do
    subject(:response) { described_class.all }

    let(:expected_cats) { [lviv_pricy_cat, lviv_cheapest_cat, kharkiv_priciest_cat, kharkiv_cheap_cat] }

    it { is_expected.to match_array(expected_cats) }
  end
end
