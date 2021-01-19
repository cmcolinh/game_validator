# frozen string_literal: true

require 'game_validator/validator/result/failure'
require 'game_validator/validator/result/failure/node'

module GameValidator
  class Validator
    class Result < SimpleDelegator
      class Failure
        class Builder
          def call(errors:)
            GameValidator::Validator::Result::Failure::new(
              node: GameValidator::Validator::Result::Failure::Node::new(errors: errors))
          end
        end
      end
    end
  end
end

