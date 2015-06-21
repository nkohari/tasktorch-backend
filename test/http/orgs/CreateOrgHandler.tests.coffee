_                = require 'lodash'
expect           = require('chai').expect
TestData         = require 'test/framework/TestData'
TestHarness      = require 'test/framework/TestHarness'
CommonBehaviors  = require 'test/framework/CommonBehaviors'
CreateOrgHandler = require 'apps/api/handlers/orgs/CreateOrgHandler'

describe 'CreateOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateOrgHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['orgs', 'stacks'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->
    payload = {}
    it 'returns 400 bad request', (done) ->
      @tester.request {credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid name argument', ->
    payload = {name: new Date().valueOf().toString()}
    it 'creates the org and adds the requester as a leader and member', (done) ->
      @tester.request {credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {org} = res.result
        expect(org).to.exist()
        expect(org.name).to.equal(payload.name)
        expect(org.leaders).to.have.members ['user-charlie']
        expect(org.members).to.have.members ['user-charlie']
        reset(done)

#---------------------------------------------------------------------------------------------------
