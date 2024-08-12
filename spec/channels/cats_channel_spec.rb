# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatsChannel do
  describe '#subscribed' do
    it 'successfully subscribes to the cats_channel stream' do
      subscribe
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from('cats_channel')
    end
  end

  describe '#unsubscribed' do
    before { subscribe }

    it 'successfully unsubscribes from the stream' do
      subscription.unsubscribe_from_channel
      expect(subscription).not_to have_stream_from('cats_channel')
    end
  end
end
