# frozen_string_literal: true

RSpec.shared_examples 'paginated resource' do
  it 'returns pagination meta' do
    expect(json[:meta][:pagy]).to have_pagy_keys
  end
end
