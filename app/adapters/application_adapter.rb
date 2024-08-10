# frozen_string_literal: true

class ApplicationAdapter
  attr_reader :object

  def initialize(object)
    @object = object
  end
end
