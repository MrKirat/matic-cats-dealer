require 'rails_helper'

RSpec.describe '/api/v1/cats' do
  describe 'GET index' do
    include_context 'with diverse cats'

    before do
      allow(CatRepository).to receive(:all).and_return(diverse_cats)
      get '/api/v1/cats', params:
    end

    let(:params) { {} }

    let(:lviv_cheapest_cat_json) do
      {
        price: lviv_cheapest_cat.price, breed: lviv_cheapest_cat.breed,
        location: lviv_cheapest_cat.location, image: lviv_cheapest_cat.image
      }
    end

    let(:lviv_pricy_cat_json) do
      {
        price: lviv_pricy_cat.price, breed: lviv_pricy_cat.breed,
        location: lviv_pricy_cat.location, image: lviv_pricy_cat.image
      }
    end

    let(:kharkiv_cheap_cat_json) do
      {
        price: kharkiv_cheap_cat.price, breed: kharkiv_cheap_cat.breed,
        location: kharkiv_cheap_cat.location, image: kharkiv_cheap_cat.image
      }
    end

    let(:kharkiv_priciest_cat_json) do
      {
        price: kharkiv_priciest_cat.price, breed: kharkiv_priciest_cat.breed,
        location: kharkiv_priciest_cat.location, image: kharkiv_priciest_cat.image
      }
    end

    it_behaves_like 'paginated resource'

    context 'without parameters' do
      let(:expected_cats) do
        [lviv_cheapest_cat_json, lviv_pricy_cat_json, kharkiv_cheap_cat_json, kharkiv_priciest_cat_json]
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns expected cats' do
        expect(json[:cats]).to match_array(expected_cats)
      end
    end

    context 'with provided location' do
      let(:params) { { location: 'Kharkiv' } }
      let(:expected_cats) { [kharkiv_cheap_cat_json, kharkiv_priciest_cat_json] }

      it 'returns cats from chosen location' do
        expect(json[:cats]).to match_array(expected_cats)
      end
    end

    context 'with provided breed' do
      let(:params) { { breed: kharkiv_cheap_cat.breed } }
      let(:expected_cats) { [kharkiv_cheap_cat_json] }

      it 'returns cats with chosen breed' do
        expect(json[:cats]).to eq(expected_cats)
      end
    end

    context 'when sorted from cheapest to most expensive' do
      let(:params) { { sort: 'cheap_first' } }

      it 'returns cats with chosen breed' do
        expect(json[:cats].first[:price]).to be < json[:cats].second[:price]
        expect(json[:cats].second[:price]).to be < json[:cats].third[:price]
        expect(json[:cats].third[:price]).to be < json[:cats].fourth[:price]
      end
    end

    context 'with invalid parameters' do
      let(:params) { { sort: 'invalid_order', location: nil, breed: '' } }

      it 'returns cats with chosen breed' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json).to eq errors: {
          breed: ['must be filled'], location: ['must be filled'],
          sort: ['must be one of: cheap_first, expensive_first']
        }
      end
    end

    context 'when looking for the cheapest cat in Lviv' do
      let(:params) { { sort: 'cheap_first', location: 'Lviv', limit: 1 } }

      it 'returns the cheapest cat in Lviv' do
        expect(json[:cats]).to contain_exactly lviv_cheapest_cat_json
      end
    end
  end

  describe 'POST search' do
    let(:params) { { location: 'Lviv', breed: 'Siamese', sort: 'cheap_first', page: '1', limit: '1' } }

    it 'enqueues the async job with the correct parameters' do
      expect { post '/api/v1/cats/search', params: }.to have_enqueued_job(
        Cats::SendSearchResultJob
      ).with(include(params)).on_queue('default')

      expect(response).to have_http_status(:ok)
      expect(json).to eq message: 'The result will be delivered via the cats_channel.'
    end
  end
end
