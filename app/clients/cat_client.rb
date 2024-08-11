# frozen_string_literal: true

# CatClient is a specialized HTTP client used to interact with external
# cat data sources. It inherits from `ApplicationClient` and provides
# methods to fetch cat data in different formats.
#
# The base URI for the client is configured to point to the external
# API that provides the cat data.
#
class CatClient < ApplicationClient
  base_uri 'nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/'

  class << self
    # Fetches cat data in JSON format from the Cats Unlimited shop.
    #
    # @return [HTTParty::Response] The HTTP response object containing information about cats.
    def cats_unlimited = get('/json', format: :json)

    # Fetches cat data in XML format from the Happy Cats shop.
    #
    # @return [HTTParty::Response] The HTTP response object containing information about cats.
    def happy_cats     = get('/xml',  format: :xml)
  end
end
