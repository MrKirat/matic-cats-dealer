# frozen_string_literal: true

class CatClient < ApplicationClient
  base_uri 'nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/'

  class << self
    def cats_unlimited = get('/json', format: :json)
    def happy_cats     = get('/xml',  format: :xml)
  end
end
