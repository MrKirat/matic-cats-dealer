# frozen_string_literal: true

# CatsController is responsible for handling requests related to the list of cats.
module Api
  module V1
    class CatsController < ApplicationController
      # Handles the `GET /cats` request.
      #
      # CatsController is responsible for handling requests related to the list of cats.
      # The `index` action retrieves a list of cats based on the provided query parameters,
      # applies filtering and sorting, paginates the results, and renders them as JSON.
      #
      # ### Acceptable Query Parameters:
      #
      # - `location` (optional, String): Filters the cats based on their location.
      #   - Example: `?location=Lviv`
      #
      # - `breed` (optional, String): Filters the cats based on their breed.
      #   - Example: `?breed=Siamese`
      #
      # - `sort` (optional, String): Determines the sorting order of the cats based on their price.
      #   Accepts the following values:
      #   - `cheap_first`: Sorts the cats in ascending order of price (cheapest first).
      #   - `expensive_first`: Sorts the cats in descending order of price (most expensive first).
      #   - Example: `?sort=cheap_first`
      #
      # - `limit` (optional, Integer): Limits the number of cats returned in the response.
      #   - Example: `?limit=10`
      #
      # - `page` (optional, Integer): Specifies the page of results to retrieve, in combination with the `limit`.
      #   - Example: `?page=2`
      #
      # ### Example Request:
      #
      # `GET /api/v1/cats?location=Lviv&breed=Siamese&sort=cheap_first&limit=1&page=1`
      #
      # This example retrieves the cheapest cat of Siamese breed located in Lviv.
      #
      # @return [void]
      def index
        case ::Cats::ListOperation.call(params)
        in Success[*cats]
          pagy, cats = pagy_array(cats)
          render json: ::CatBlueprint.render(cats, root: :cats, meta: { pagy: pagy_metadata(pagy) })
        in Failure[status, errors]
          render json: { errors: }, status:
        else
          head :internal_server_error
        end
      end

      # Handles the `POST /cats/search` request.
      #
      # This action triggers an asynchronous search operation for cats based on the provided query parameters.
      # The search results will be processed in the background and delivered via the `cats_channel`
      # using ActionCable. This allows the client to subscribe to the channel and receive the search
      # results once they are ready.
      #
      # @param params [Hash] The query parameters for the search. These parameters include:
      #   - `location` (optional, String): Filters the cats based on their location.
      #   - `breed` (optional, String): Filters the cats based on their breed.
      #   - `sort` (optional, String): Determines the sorting order of the cats based on their price.
      #     Accepts the following values:
      #     - `cheap_first`: Sorts the cats in ascending order of price (cheapest first).
      #     - `expensive_first`: Sorts the cats in descending order of price (most expensive first).
      #   - `limit` (optional, Integer): Limits the number of cats returned in the response.
      #   - `page` (optional, Integer): Specifies the page of results to retrieve, in combination with the `limit`.
      #
      # @example Example Request
      #   POST /api/v1/cats/search
      #   {
      #     "location": "Lviv",
      #     "breed": "Siamese",
      #     "sort": "cheap_first",
      #     "limit": 10,
      #     "page": 1
      #   }
      #
      # @return [void] Renders a JSON message confirming that the result will be delivered via the cats_channel.
      #   - Example Response: `{ "message": "The result will be delivered via the cats_channel." }`
      def search
        ::Cats::SendSearchResultJob.perform_later(params.to_unsafe_h)
        render json: { message: 'The result will be delivered via the cats_channel.' }
      end
    end
  end
end
