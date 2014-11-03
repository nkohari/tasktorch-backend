exports.encode = (str) ->
  '\"' + str + '\"'

exports.decode = (str) ->
  str.substr(1, str.length - 2)
