humanize = module.exports = (str) ->
  str.replace(/([A-Z])/g, ' $1').substr(1).toLowerCase()
