# frozen_string_literal: true

class CatRepository
  SOURCES = [
    { client: ::CatClient, method: :cats_unlimited, adapter: ::CatsUnlimitedAdapter },
    { client: ::CatClient, method: :happy_cats, adapter: ::HappyCatsAdapter }
  ].freeze

  def self.all
    SOURCES.flat_map do |source|
      source[:adapter].new(source[:client].public_send(source[:method])).all
    end
  end
end
