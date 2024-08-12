# frozen_string_literal: true

module Cats
  class SendSearchResultJob < ApplicationJob
    delegate :api_v1_cats_path, to: '::Rails.application.routes.url_helpers'

    def perform(params)
      ::ActionCable.server.broadcast 'cats_channel', result(params)
    end

    private

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
