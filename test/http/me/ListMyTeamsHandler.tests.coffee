_                  = require 'lodash'
expect             = require('chai').expect
TestHarness        = require 'test/framework/TestHarness'
CommonBehaviors    = require 'test/framework/CommonBehaviors'
ListMyTeamsHandler = require 'http/handlers/me/ListMyTeamsHandler'

describe 'ListMyTeamsHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListMyTeamsHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->
    it 'returns an array of teams owned by the requester in that org', (done) ->
      @tester.request {orgid: 'org-paddys', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {teams} = res.result
        expect(teams).to.be.an('array')
        expect(teams).to.have.length(2)
        expect(_.pluck(teams, 'id')).to.have.members ['team-thegang', 'team-gruesometwosome']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
