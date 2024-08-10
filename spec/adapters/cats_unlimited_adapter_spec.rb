# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatsUnlimitedAdapter do
  let(:adapter) { described_class.new(response) }

  describe '.all' do
    subject { adapter.all }

    context 'when response is unsuccessful' do
      let(:response) { instance_double(HTTParty::Response, success?: false) }

      it { is_expected.to be_empty }
    end

    context 'when response is successful' do
      let(:response) { instance_double(HTTParty::Response, success?: true, parsed_response: cats) }
      let(:cats) { %w[cat1 cat1] }

      it { is_expected.to eq cats }
    end
  end
end
