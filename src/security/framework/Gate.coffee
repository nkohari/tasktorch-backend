class Gate

  getAccessList: (document, callback) ->
    throw new Error("You must implement getAccessList() on #{@constructor.name}")

module.exports = Gate
