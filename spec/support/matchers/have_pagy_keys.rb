# frozen_string_literal: true

RSpec::Matchers.matcher :have_pagy_keys do
  match do |actual|
    expect(actual.keys).to eq Pagy::DEFAULT[:metadata]
  end
end
