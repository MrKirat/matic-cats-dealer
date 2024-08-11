# frozen_string_literal: true

# CatsController is responsible for handling requests related to the list of cats.
# It leverages the `Cats::ListOperation` to filter and sort cats based on the provided parameters,
# and then uses pagination and rendering to deliver the response.
#
# The controller action `index` supports the following flow:
# 1. It calls the `ListOperation` with the request parameters.
# 2. Depending on the result (Success or Failure), it either renders the cats list
#    or an error response.
# 3. If the operation is successful, the result is paginated using `pagy_array`
#    and rendered using `CatBlueprint`.
#
# The controller also includes error handling for unexpected conditions.
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
