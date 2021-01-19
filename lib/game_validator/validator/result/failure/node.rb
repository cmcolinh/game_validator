# frozen string_literal: true

require 'dry-initializer'
require 'dry-types'

module GameValidator
  class Validator
    class Result < SimpleDelegator
      class Failure
        class Node
          extend Dry::Initializer
          option :errors, type: Types.Interface(:messages)

          def accept(visitor)
            visitor = Types.Interface(:handle_validation_error).call(visitor)
            visitor.handle_validation_error(self)
          end
        end
      end
    end
  end
end

