_                 = require 'lodash'
expect            = require('chai').expect
TestData          = require 'test/framework/TestData'
TestHarness       = require 'test/framework/TestHarness'
CommonBehaviors   = require 'test/framework/CommonBehaviors'
CreateUserHandler = require 'http/handlers/users/CreateUserHandler'
GetTokenQuery     = require 'data/queries/tokens/GetTokenQuery'

describe 'CreateUserHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateUserHandler)
      @database = TestHarness.getDatabase()
      ready()

  reset = (callback) ->
    TestData.reset ['tokens', 'users'], callback

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->
    payload = {username: 'waitress', password: 'dennis', email: 'waitress@coffeeshop.com', token: 'token-waitress'}
    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a username argument', ->
    payload = {name: 'Waitress', password: 'dennis', email: 'waitress@coffeeshop.com', token: 'token-waitress'}
    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a password argument', ->
    payload = {name: 'Waitress', username: 'waitress', email: 'waitress@coffeeshop.com', token: 'token-waitress'}
    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a email argument', ->
    payload = {name: 'Waitress', username: 'waitress', password: 'dennis', token: 'token-waitress'}
    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a token argument', ->
    payload = {name: 'Waitress', username: 'waitress', email: 'waitress@coffeeshop.com', password: 'dennis'}
    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with valid arguments', ->
    payload = {name: 'Waitress', username: 'waitress', password: 'dennis', email: 'waitress@coffeeshop.com', token: 'token-waitress'}
    it 'creates and returns the user', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        expect(user).to.exist()
        expect(user.name).to.equal(payload.name)
        expect(user.username).to.equal(payload.username)
        reset(done)
    it 'deletes the token', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetTokenQuery(payload.token, {allowDeleted: true})
        @database.execute query, (err, result) =>
          expect(err).to.not.exist()
          expect(result.token).to.exist()
          expect(result.token.status).to.equal('Deleted')
          reset(done)

#---------------------------------------------------------------------------------------------------
