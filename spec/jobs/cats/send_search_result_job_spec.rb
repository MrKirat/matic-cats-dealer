# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cats::SendSearchResultJob do
  let(:params) { { location: 'Lviv', breed: 'Siamese' } }

  describe '#perform' do
    subject(:perform) { described_class.perform_now(params) }

    context 'when the operation is successful' do
      let(:cats) { [build(:cat)] }

      before do
        allow(Cats::ListOperation).to receive(:call).with(params).and_return(Dry::Monads::Success(cats))
        allow(CatBlueprint).to receive(:render).with(cats, root: :cats).and_return('serialization result')
      end

      it 'broadcasts the success result to cats_channel' do
        expect(ActionCable.server).to receive(:broadcast).with('cats_channel', 'serialization result')
        perform
      end
    end

    context 'when the operation fails' do
      let(:errors) { { breed: ['must be filled'] } }
      let(:status) { :unprocessable_entity }

      before do
        allow(Cats::ListOperation).to receive(:call).with(params).and_return(Dry::Monads::Failure([status, errors]))
      end

      it 'broadcasts the failure result to cats_channel' do
        expect(ActionCable.server).to receive(:broadcast).with('cats_channel', { errors:, status: })
        perform
      end
    end

    context 'when the operation returns an unknown state' do
      before do
        allow(Cats::ListOperation).to receive(:call).with(params).and_return(nil)
      end

      it 'broadcasts an internal server error status to cats_channel' do
        expect(ActionCable.server).to receive(:broadcast).with('cats_channel', { status: :internal_server_error })
        perform
      end
    end
  end
end
