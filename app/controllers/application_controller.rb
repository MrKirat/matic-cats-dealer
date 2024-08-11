# frozen_string_literal: true

# ApplicationController is the base controller class from which all other API controllers inherit.
# It includes shared functionality such as Dry-Monads for result handling and Pagy for pagination.
#
# The inclusion of Dry-Monads provides a consistent way to handle success and failure outcomes
# in controller actions, allowing for more expressive and clear code.
#
# The inclusion of Pagy allows for efficient and flexible pagination of large collections.
class ApplicationController < ActionController::API
  include ::Dry::Monads[:result]
  include ::Pagy::Backend
end
