_                      = require 'lodash'
expect                 = require('chai').expect
TestHarness            = require 'test/framework/TestHarness'
ListGoalsByCardHandler = require 'apps/api/handlers/goals/ListGoalsByCardHandler'

describe 'goals:ListGoalsByCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListGoalsByCardHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    cardid = 'card-buygas'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, cardid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid  = 'doesnotexist'
    cardid = 'card-buygas'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->

    orgid  = 'org-paddys'
    cardid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for valid card in an org of which the requester is a member', ->

    orgid  = 'org-paddys'
    cardid = 'card-buygas'

    it 'returns an array of goals defined for the card', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {goals} = res.result
        expect(goals).to.exist
        expect(goals).to.have.length(1)
        expect(_.pluck(goals, 'id')).to.have.members ['goal-gascrisis']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a mismatched orgid and cardid', ->

    orgid  = 'org-paddys'
    cardid = 'card-ringbell'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid  = 'org-sudz'
    cardid = 'card-ringbell'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
