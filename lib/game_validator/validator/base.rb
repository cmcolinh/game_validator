# frozen string_literal: true

require 'dry-validation'
require 'dry-initializer'

Dry::Validation.load_extensions(:monads)

module GameValidator
  class Validator
    class Base < Dry::Validation::Contract
      extend Dry::Initializer
      option :legal_options, type: Types::Array.of(Types::String)
      option :next_player_id, type: Types::Coercible::Integer

      params do
        required(:player_action).filled(:string)
        required(:user).filled(Types.Interface(:id, :admin?))
      end

      rule(:player_action) do
        if !legal_options.include?(values[:player_action])
          key.failure({text: "player_action '#{values[:player_action]}' is not permitted", status: 400})
        end
      end

      rule(:user) do
        if !values[:user].id.eql?(next_player_id) && !values[:user].admin?
          key.failure({text: 'Not logged in', status: 401})
        end
      end
    end
  end
end

