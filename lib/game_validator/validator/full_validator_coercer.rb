# frozen string_literal: true

require 'dry-types'

module GameValidator
  class Validator
    class FullValidatorCoercer
      def call(validator_hash)
        Types::Hash.call(validator_hash) # throw exception if not given a hash
        result = {}
        validator_hash.each do |key, value|
          if key.is_a?(Array)
            if key.length != 2
              raise Dry::Types::ConstraintError::new("Array keys must have two elements given #{key}", key)
            end
            if !key.first.is_a?(String) && !key.first.is_a?(Symbol)
              raise Dry::Types::ConstraintError::new("first part of array key must be a String or Symbol, given #{key}", key)
            end
            if !key.last.eql?(true) && !key.last.eql?(false)
              raise Dry::Types::ConstraintError::new("last part of array key must be a boolean, given #{key}", key)
            end
            result[["#{key.first}".freeze, key.last]] = Types.Interface(:call).call(value)
          elsif key.is_a?(String) || key.is_a?(Symbol)
            if key.length.eql?(0)
              raise Dry::Types::ConstraintError::new('Empty String or Symbol key not permitted', key)
            end
            result[["#{key}".freeze, false]] = Types.Interface(:call).call(value)
            result[["#{key}".freeze, true]] = Types.Interface(:call).call(value)
          else
            raise Dry::Types::ConstraintError::new('key must be a String, Symbol, or an Array', key)
          end
        end
        result
      end
    end
  end
end

