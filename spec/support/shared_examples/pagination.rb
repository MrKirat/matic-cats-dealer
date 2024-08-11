# frozen_string_literal: true

RSpec.shared_examples 'paginated resource' do |parameter|
  it 'returns pagination meta' do
    expect(json[:meta][:pagy].keys).to eq Pagy::DEFAULT[:metadata]
  end
end
