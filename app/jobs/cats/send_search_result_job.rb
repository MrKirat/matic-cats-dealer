# frozen_string_literal: true

module Cats
  # SendSearchResultJob is responsible for processing a search request for cats
  # and broadcasting the results to the 'cats_channel' via ActionCable.
  #
  # This job asynchronously handles the search operation by calling the Cats::ListOperation
  # and broadcasting the resulting data or errors to the 'cats_channel'.
  #
  # @example Triggering the job
  #   Cats::SendSearchResultJob.perform_later(search_params)
  #
  # @param params [Hash] The parameters used to filter and sort the list of cats.
  #   Accepts the following keys:
  #   - `location` (optional, String): Filters the cats based on their location.
  #   - `breed` (optional, String): Filters the cats based on their breed.
  #   - `sort` (optional, String): Determines the sorting order of the cats based on their price.
  #   - `limit` (optional, Integer): Limits the number of cats returned in the response.
  #   - `page` (optional, Integer): Specifies the page of results to retrieve.
  #
  class SendSearchResultJob < ApplicationJob
    delegate :api_v1_cats_path, to: '::Rails.application.routes.url_helpers'

    # Performs the job by broadcasting the search results or errors to the 'cats_channel'.
    #
    # @param params [Hash] The parameters used to filter and sort the list of cats.
    # @return [void]
    def perform(params)
      ::ActionCable.server.broadcast 'cats_channel', result(params)
    end

    private

    # Processes the search results and prepares the data to be broadcasted.
    #
    # This method invokes the Cats::ListOperation to obtain the filtered and sorted list of cats.
    # It also paginates the results and renders them using the CatBlueprint.
    #
    # @param params [Hash] The parameters used to filter and sort the list of cats.
    # @return [String, Hash] The JSON string of cats data if successful, or a hash with errors and status.
    def result(params)
      case ::Cats::ListOperation.call(params)
      in Success[*cats]
        pagy, cats = pagy_array(cats, url: api_v1_cats_path)
        ::CatBlueprint.render(cats, root: :cats, meta: { pagy: pagy_metadata(pagy) })
      in Failure[status, errors]
        { errors:, status: }
      else
        { status: :internal_server_error }
      end
    end
  end
end
