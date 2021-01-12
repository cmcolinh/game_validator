# frozen string_literal: true

require 'game_validator/validator/base'

module GameValidator
  class Validator
    extend Dry::Initializer
    option :validate_player_action_and_user, type: Types.Interface(:call)
    option :full_validator_for, type: Types::Hash

    def call(action_hash:, user:)
      a = action_hash.dup
      a[:user] = user
      result = validate_player_action_and_user.(a)
      return result if result.failure?
      validate = full_validator_for[[a[:player_action], a[:user].admin?]]
      validate.(a)
    end
  end
end

