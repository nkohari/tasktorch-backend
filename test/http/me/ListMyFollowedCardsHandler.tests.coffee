_                          = require 'lodash'
expect                     = require('chai').expect
TestHarness                = require 'test/framework/TestHarness'
ListMyFollowedCardsHandler = require 'apps/api/handlers/me/ListMyFollowedCardsHandler'

describe 'me:ListMyFollowedCardsHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListMyFollowedCardsHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->

    orgid = 'org-paddys'

    it 'returns an array of cards followed by the requester in that org', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {cards} = res.result
        expect(cards).to.be.an('array')
        expect(cards).to.have.length(2)
        expect(_.pluck(cards, 'id')).to.have.members ['card-takedbaby', 'card-boildenim']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid = 'org-sudz'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
