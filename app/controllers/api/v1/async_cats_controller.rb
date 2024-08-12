# frozen_string_literal: true

module Api
  module V1
    class AsyncCatsController < ApplicationController
      def index
        ::Cats::SendIndexResultJob.perform_later(params.to_unsafe_h)
        head :ok
      end
    end
  end
end
