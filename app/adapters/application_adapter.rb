# frozen_string_literal: true

# ApplicationAdapter is a generic base class designed to adapt any given object
# to a desired interface or format. It provides a consistent initialization pattern
# and serves as a foundation for creating specific adapters that transform data
# or behavior from one form to another.
#
# This class is intentionally abstract and does not impose any constraints on what
# the `object` can be or how it should be adapted, making it highly flexible and
# reusable across different contexts and domains.
#
class ApplicationAdapter
  # @!attribute [r] object
  #   @return [Object] The object to be adapted.
  attr_reader :object

  # Initializes a new adapter with the given object.
  #
  # The `object` can be any kind of input that needs to be adapted or transformed.
  # Subclasses should implement specific methods to define how the `object` should
  # be processed or converted to the desired output.
  #
  # @param object [Object] The object to be adapted.
  def initialize(object)
    @object = object
  end
end
