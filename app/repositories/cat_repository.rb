# frozen_string_literal: true

# CatRepository is responsible for aggregating and retrieving data
# from multiple external sources that provide information about cats.
#
# The class uses a list of sources, each defined by a client, method,
# and adapter. It then retrieves data from each source, adapts it
# using the specified adapter, and returns a combined list of all cats.
#
class CatRepository
  # An array of sources from which cat data is retrieved. Each source
  # is a hash that includes:
  #   - `:client` [Class] The client class used to fetch data from the source.
  #   - `:method` [Symbol] The method to be called on the client to fetch the data.
  #   - `:adapter` [Class] The adapter class used to transform the data.
  #
  # @return [Array<Hash>] The list of sources.
  SOURCES = [
    { client: ::CatClient, method: :cats_unlimited, adapter: ::CatsUnlimitedAdapter },
    { client: ::CatClient, method: :happy_cats, adapter: ::HappyCatsAdapter }
  ].freeze

  # Fetches all cats from all configured sources.
  #
  # The method iterates over each source, calls the specified method on
  # the client, adapts the data using the specified adapter, and then
  # combines all the results into a single array.
  #
  # @example Retrieve all cats
  #   cats = CatRepository.all
  #
  # @return [Array<Object>] A combined array of all cats from all sources.
  def self.all
    SOURCES.flat_map do |source|
      source[:adapter].new(source[:client].public_send(source[:method])).all
    end
  end
end
