# frozen_string_literal: true

RSpec::Matchers.matcher :have_pagy_keys do |expected|
  match do |actual|
    expect(actual.keys).to eq Pagy::DEFAULT[:metadata]
  end
end
