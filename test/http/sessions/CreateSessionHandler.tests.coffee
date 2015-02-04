_                    = require 'lodash'
expect               = require('chai').expect
TestData             = require 'test/framework/TestData'
TestHarness          = require 'test/framework/TestHarness'
CommonBehaviors      = require 'test/framework/CommonBehaviors'
CreateSessionHandler = require 'http/handlers/sessions/CreateSessionHandler'

describe 'CreateSessionHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateSessionHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['sessions'], callback

#---------------------------------------------------------------------------------------------------

  describe 'when called without a login argument', ->
    payload = {password: 'waitress'}
    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a password argument', ->
    payload = {login: 'dayman'}
    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid username but an incorrect password', ->
    payload = {login: 'dayman', password: 'hunter2'}
    it 'returns 403 forbidden', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid email but an incorrect password', ->
    payload = {login: 'charlie.kelly@paddyspub.com', password: 'hunter2'}
    it 'returns 403 forbidden', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid username and a valid password', ->
    payload = {login: 'dayman', password: 'waitress'}
    it 'returns the created session', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {session} = res.result
        expect(session).to.exist()
        expect(session.user).to.equal('user-charlie')
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid email and a valid password', ->
    payload = {login: 'charlie.kelly@paddyspub.com', password: 'waitress'}
    it 'returns the created session', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {session} = res.result
        expect(session).to.exist()
        expect(session.user).to.equal('user-charlie')
        reset(done)

#---------------------------------------------------------------------------------------------------
