# frozen string_literal: true

require 'game_validator/validator/result/failure'
require 'game_validator/validator/result/failure/node'
require 'game_validator/validator/result/failure/builder'

module GameValidator
  class Validator
    class Result < SimpleDelegator
      def initialize(result:, execute:)
        super(Types.Interface(:failure?, :success?, :to_h).call(result))
        @execute = Types.Interface(:call).call(execute)
      end

      def call(**args)
        @execute.(to_h.merge(args))
      end
    end
  end
end

