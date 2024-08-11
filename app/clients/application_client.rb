# frozen_string_literal: true

# ApplicationClient is a base class for all HTTP clients in the application.
# It provides basic HTTP functionalities by including the `HTTParty` module,
# allowing subclasses to easily make HTTP requests to external services.
#
# Subclasses should define specific methods for interacting with particular
# endpoints or services.
#
class ApplicationClient
  include HTTParty
end
