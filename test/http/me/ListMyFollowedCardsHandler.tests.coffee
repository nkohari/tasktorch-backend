_                          = require 'lodash'
expect                     = require('chai').expect
TestHarness                = require 'test/framework/TestHarness'
CommonBehaviors            = require 'test/framework/CommonBehaviors'
ListMyFollowedCardsHandler = require 'apps/api/handlers/me/ListMyFollowedCardsHandler'

describe 'ListMyFollowedCardsHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListMyFollowedCardsHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->
    it 'returns an array of cards followed by the requester in that org', (done) ->
      @tester.request {orgid: 'org-paddys', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {cards} = res.result
        expect(cards).to.be.an('array')
        expect(cards).to.have.length(2)
        expect(_.pluck(cards, 'id')).to.have.members ['card-takedbaby', 'card-boildenim']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
