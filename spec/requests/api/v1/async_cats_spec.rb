# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/async_cats' do
  describe 'GET index' do
    let(:params) do
      { location: 'Lviv', breed: 'Siamese', sort: 'cheap_first' }
    end

    it 'enqueues the async job with the correct parameters' do
      expect { get '/api/v1/async_cats', params: }.to have_enqueued_job(
        Cats::SendIndexResultJob
      ).with(include(params)).on_queue('default')

      expect(response).to have_http_status(:ok)
    end
  end
end
