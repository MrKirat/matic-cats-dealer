# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ::Dry::Monads[:result]
  include ::Pagy::Backend
end
