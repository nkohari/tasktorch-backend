_        = require 'lodash'
Relation = require './Relation'

SCHEMA_MAP = {}

class Schema

  @create: (name, spec) ->
    schema = SCHEMA_MAP[name] = new this(name, spec)
    return schema

  @get: (name) ->
    schema = SCHEMA_MAP[name]
    throw new Error("No schema named #{name} has been defined") unless schema?
    return schema

  constructor: (@name, spec) ->
    @table = spec.table
    @relations = _.object _.map spec.relations, (rspec, name) =>
      [name, new Relation(this, name, rspec)]

  getRelation: (name) ->
    relation = @relations[name]
    throw new Error("The schema #{@name} does not define a relation named #{name}") unless relation?
    return relation

module.exports = Schema
