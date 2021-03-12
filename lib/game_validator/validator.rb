# frozen string_literal: true

require 'game_validator/validator/base'
require 'game_validator/validator/full_validator_coercer'

module GameValidator
  class Validator
    extend Dry::Initializer
    option :validate_player_action_and_user, type: Types.Interface(:call)
    option :full_validator_for, type: Types::Hash
    option :build_failure, type: Types.Interface(:call),
      default: ->{GameValidator::Validator::Result::Failure::Builder::new}

    def call(action_hash:, user:)
      a = action_hash.dup
      a[:user] = user
      result = validate_player_action_and_user.(a)
      return build_failure.(errors: result.errors) if result.failure?
      validate = full_validator_for[[a[:player_action], a[:user].admin?]]
      result = validate.(action_hash)
      return build_failure.(errors: result.errors) if result.failure?
      result
    end
  end
end

