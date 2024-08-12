# frozen_string_literal: true

module Cats
  class SendIndexResultJob < ApplicationJob
    def perform(params)
      ::ActionCable.server.broadcast 'cats_channel', result(params)
    end

    private

    def result(params)
      case ::Cats::ListOperation.call(params)
      in Success[*cats]
        ::CatBlueprint.render(cats, root: :cats)
      in Failure[status, errors]
        { errors:, status: }
      else
        { status: :internal_server_error }
      end
    end
  end
end
