_                     = require 'lodash'
expect                = require('chai').expect
TestHarness           = require 'test/framework/TestHarness'
ListGoalsByOrgHandler = require 'apps/api/handlers/goals/ListGoalsByOrgHandler'

describe 'goals:ListGoalsByOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListGoalsByOrgHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid = 'org-oldiesrockcafe'

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->

    orgid = 'org-paddys'

    it 'returns an array of goals defined for the org', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {goals} = res.result
        expect(goals).to.exist
        expect(goals).to.have.length(2)
        expect(_.pluck(goals, 'id')).to.have.members ['goal-streetfighter', 'goal-gascrisis']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid = 'org-sudz'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
