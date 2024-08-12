# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include ::Dry::Monads[:result]
  include ::Pagy::Backend

  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError
end
