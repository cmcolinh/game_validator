# frozen string_literal: true

module GameValidator
  class Validator
    class Result < SimpleDelegator
      class Failure
        extend Dry::Initializer
        option :node, type: Types.Interface(:accept)

        def call(**args)
          change_orders = Types.Interface(:push).call(args[:change_orders])
          change_orders = change_orders.push(node)
          change_orders
        end

        def failure?
          true
        end

        def success?
          false
        end
      end
    end
  end
end

