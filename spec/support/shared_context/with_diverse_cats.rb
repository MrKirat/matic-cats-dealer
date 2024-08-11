# frozen_string_literal: true

RSpec.shared_context 'with diverse cats' do
  let(:lviv_pricy_cat)        { build(:cat, :pricy,    :lviv) }
  let(:lviv_cheapest_cat)     { build(:cat, :cheapest, :lviv) }
  let(:kharkiv_priciest_cat)  { build(:cat, :priciest, :kharkiv) }
  let(:kharkiv_cheap_cat)     { build(:cat, :cheap,    :kharkiv) }
  let(:diverse_cats)          { [lviv_pricy_cat, lviv_cheapest_cat, kharkiv_priciest_cat, kharkiv_cheap_cat] }
end
