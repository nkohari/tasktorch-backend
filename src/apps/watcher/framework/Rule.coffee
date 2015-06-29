class Rule

  offer: (activity, event) ->
    throw new Error("You must implement offer() on #{@constructor.name}")

  handle: (activity, event, callback) ->
    throw new Error("You must implement handle() on #{@constructor.name}")

module.exports = Rule
