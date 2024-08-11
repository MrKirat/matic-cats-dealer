# frozen_string_literal: true

module Api
  module V1
    class CatsController < ApplicationController
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
    end
  end
end
