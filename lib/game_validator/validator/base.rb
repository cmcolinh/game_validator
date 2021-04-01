# frozen string_literal: true

require 'dry-validation'

Dry::Validation.load_extensions(:monads)

module GameValidator
  class Validator
    class Base < Dry::Validation::Contract
      option :legal_options, type: Types::ArrayOfString
      option :current_player_id, type: Types::Coercible::Integer
      option :last_action_id, type: Types::Coercible::Integer

      params do
        required(:player_action).filled(:string)
        required(:user).filled(Types.Interface(:id, :admin?))
        required(:last_action_id).filled(:integer)
      end

      rule(:player_action) do
        if !legal_options.include?(values[:player_action])
          key.failure({text: "player_action '#{values[:player_action]}' is not permitted", status: 400})
        end
      end

      rule(:user) do
        if !values[:user].id.eql?(current_player_id) && !values[:user].admin?
          key.failure({text: 'Not logged in', status: 401})
        end
      end

      rule(:last_action_id) do
        if values[:last_action_id] < last_action_id
          key.failure({text: "last_action_id '#{values[:last_action_id]}' is obsolete",status: 409})
        end

        if values[:last_action_id] > last_action_id
          key.failure({text: "last_action_id '#{values[:last_action_id]}' not a match",status: 400})
        end
      end
    end
  end
end

