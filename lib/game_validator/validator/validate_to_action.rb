# frozen string_literal: true

require 'dry-initializer'

module GameValidator
  class Validator
    class ValidateToAction
      extend Dry::Initializer
      option :validate, type: Types.Interface(:call)
      option :wrap, type: Types.Interface(:call)

      def call(action_hash)
        result = validate.(action_hash)
        result = wrap.(result) if result.success?
        result
      end
    end
  end
end

