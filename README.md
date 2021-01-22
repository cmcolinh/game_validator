# GameValidator

This gem is a wrapper on 'dry-validation' to validate the entire input in two or more passes.

The first pass will verify only that the user is valid and the player action is valid.  If and only if the first pass is successful, a second pass will be made to verify the input against a validator specific to the user's admin status, and to the player_action selected. 


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'game_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install game_validator

## Usage

The base class of this gem is GameValidator::Validator.  It requires two dependencies.  The first, with key <b>validate_player_action_and_user</b>, is a built in class GameValidator::Validator::Base, while the second, <b>full_validator_for</b>, should be created by the application builder.

validate_player_action_and_user, where the legal player actions are 'run' and 'hide', and the player whose turn it is has an id of 1, is most easily initialized with the below code
```
GameValidator::Validator::Base::new(legal_options: ['run', 'hide'], next_player_id: 1)
```

To create the various action specific validators, wrap Dry::Validation::Contract in a manner such as this
```
class RunValidator
  extend Dry::Initializer
  option :validate, default: ->{Validator::new}
  
  class Validator < Dry::Validation::Contract
    schema do
      required(:player_action).filled(:string, eql?: 'run')
      required(:where).filled(:string, included_in?: ['here', 'there'])
    end
  end
  
  class Executor
    extend Dry::Initializer
    option :where
    def call(change_orders:, **args)
      change_orders.push(Node::new(where: where))
      change_orders
    end
  end
  
  class Node
    extend Dry::Initializer
    option :where
    def accept(visitor)
      visitor.handle_run_node(where)
    end
  end

  def call(input)
    result = validate(input)
    result.success? ? Executor::new(where: result[:where]) : result
  end
end
```
You then need to arrange all of the possible validators in a hash, with either a String or Hash key the value being the value of player_action, or a two element array as the key, the first element being the string value of player_action, and whether the validator is for an admin or non admin as the second element.  If the same validator should apply whether or not the user is an admin or not, the same element should be added twice, with the admin portion being both true and false

```
full_validator = {
  'run' => run_validator,
  ['hide', true] => hide_admin_validator,
  ['hide', false] => hide_non_admin_validator # using a hash with two elements as the key in the event I need different validators for admin and non-admin
}
```

In this fashion, you create the full validator as follows
```
GameValidator::Validator::new(
  validate_player_action_and_user: GameValidator::Validator::Base::new(legal_options: ['run', 'hide'], next_player_id: 1),
  full_validator_for: full_validator)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/game_validator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
    extend Dry::Initializer
    option :where
