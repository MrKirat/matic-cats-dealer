# frozen_string_literal: true

# CatsChannel is a WebSocket channel that allows clients to receive real-time updates
# about the search results for cats. This channel is part of the application's
# ActionCable implementation, enabling asynchronous communication between the server
# and connected clients.
#
# Clients can subscribe to this channel to receive broadcasted messages, typically
# search results, that are sent by various background jobs, such as `Cats::SendSearchResultJob`.
class CatsChannel < ApplicationCable::Channel
  # Called when the client subscribes to the channel.
  #
  # This method sets up a stream for the `cats_channel`, which allows the client
  # to receive broadcasted messages. When a client subscribes, they will start
  # receiving messages that are broadcasted to this channel.
  #
  # @return [void]
  def subscribed
    stream_from 'cats_channel'
  end

  # Called when the client unsubscribes from the channel.
  #
  # This method is used for any cleanup needed when a client unsubscribes
  # from the channel. By default, it doesn't perform any specific actions,
  # but it can be overridden to handle custom cleanup logic if necessary.
  #
  # @return [void]
  def unsubscribed; end
end
