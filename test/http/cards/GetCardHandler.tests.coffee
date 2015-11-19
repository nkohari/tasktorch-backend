_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
GetCardHandler  = require 'apps/api/handlers/cards/GetCardHandler'

describe 'cards:GetCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetCardHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, cardid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid  = 'org-oldiesrockcafe'
    cardid = 'card-takedbaby'

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, cardid}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid  = 'doesnotexist'
    cardid = 'card-takedbaby'

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

  describe 'when called for a valid card in an org of which the requester is a member', ->

    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'

    it 'returns the card', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card).to.exist
        expect(card.id).to.equal(cardid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid  = 'org-sudz'
    cardid = 'card-takedbaby'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->

    orgid  = 'org-paddys'
    cardid = 'card-ringbell'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
