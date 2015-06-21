_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
CommonBehaviors = require 'test/framework/CommonBehaviors'
GetTeamHandler  = require 'apps/api/handlers/teams/GetTeamHandler'

describe 'GetTeamHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetTeamHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', teamid: 'team-thegang'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', teamid: 'team-thegang', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent team', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', teamid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid team in an org of which the requester is a member', ->
    it 'returns the team', (done) ->
      @tester.request {orgid: 'org-paddys', teamid: 'team-thegang', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {team} = res.result
        expect(team).to.exist()
        expect(team.id).to.equal('team-thegang')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', teamid: 'team-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and teamid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', teamid: 'team-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
