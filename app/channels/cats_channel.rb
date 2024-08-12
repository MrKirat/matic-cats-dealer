# frozen_string_literal: true

class CatsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'cats_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
