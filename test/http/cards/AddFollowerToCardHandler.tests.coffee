_                        = require 'lodash'
expect                   = require('chai').expect
TestData                 = require 'test/framework/TestData'
TestHarness              = require 'test/framework/TestHarness'
CommonBehaviors          = require 'test/framework/CommonBehaviors'
AddFollowerToCardHandler = require 'apps/api/handlers/cards/AddFollowerToCardHandler'

describe 'AddFollowerToCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(AddFollowerToCardHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['cards', 'notes'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', cardid: 'card-buygas'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    orgid   = 'doesnotexist'
    cardid  = 'card-buygas'
    payload = {user: 'user-charlie'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    orgid   = 'org-paddys'
    cardid  = 'doesnotexist'
    payload = {user: 'user-charlie'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a user argument', ->
    orgid   = 'org-paddys'
    cardid  = 'card-buygas'
    payload = {}
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a user argument other than the requester', ->
    orgid   = 'org-paddys'
    cardid  = 'card-buygas'
    payload = {user: 'user-dee'}
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a card with the userid of the requester and an org of which the requester is a member', ->
    orgid   = 'org-paddys'
    cardid  = 'card-buygas'
    payload = {user: 'user-charlie'}
    it 'adds the user as a follower', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card).to.exist()
        expect(card.id).to.equal(cardid)
        expect(card.followers).to.contain(payload.user)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid   = 'org-sudz'
    cardid  = 'card-ringbell'
    payload = {user: 'user-charlie'}
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->
    orgid   = 'org-paddys'
    cardid  = 'card-ringbell'
    payload = {user: 'user-charlie'}
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
