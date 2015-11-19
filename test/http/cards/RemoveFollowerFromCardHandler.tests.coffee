_                             = require 'lodash'
expect                        = require('chai').expect
TestHarness                   = require 'test/framework/TestHarness'
RemoveFollowerFromCardHandler = require 'apps/api/handlers/cards/RemoveFollowerFromCardHandler'

describe 'cards:RemoveFollowerFromCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(RemoveFollowerFromCardHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['cards', 'notes'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'
    userid = 'user-charlie'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, cardid, userid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid  = 'org-oldiesrockcafe'
    cardid = 'card-takedbaby'
    userid = 'user-charlie'

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid, cardid, userid}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid  = 'doesnotexist'
    cardid = 'card-takedbaby'
    userid = 'user-charlie'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, userid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->

    orgid  = 'org-paddys'
    cardid = 'doesnotexist'
    userid = 'user-charlie'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, userid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a user argument other than the requester', ->

    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'
    userid = 'user-dee'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, userid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a card with the userid of the requester and an org of which the requester is a member', ->

    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'
    userid = 'user-charlie'

    it 'removes the user as a follower', (done) ->
      @tester.request {orgid, cardid, userid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {card} = res.result
        expect(card).to.exist
        expect(card.id).to.equal(cardid)
        expect(card.followers).not.to.contain(userid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid  = 'org-sudz'
    cardid = 'card-ringbell'
    userid = 'user-charlie'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, userid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->

    orgid  = 'org-paddys'
    cardid = 'card-ringbell'
    userid = 'user-charlie'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, userid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
