# frozen_string_literal: true

# ApplicationBlueprint is a base class for all Blueprinter view models in the application.
# It inherits from `Blueprinter::Base`, allowing all derived classes to define
# how objects should be serialized into JSON.
#
# This class can be used to define shared configurations or methods that should be available
# to all Blueprints in the application.
#
# @see https://github.com/procore/blueprinter Blueprinter Documentation
class ApplicationBlueprint < Blueprinter::Base
end
