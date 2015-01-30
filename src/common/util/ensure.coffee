module.exports = ensure = (condition, message, args...) ->

  return if condition

  index = 0
  message.replace /%s/g, -> args[index++]

  error = new Error("Assertion check failed: #{message}")
  error.framesToPop = 1
  throw error
