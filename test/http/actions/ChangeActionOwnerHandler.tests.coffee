expect                   = require('chai').expect
TestData                 = require 'test/framework/TestData'
TestHarness              = require 'test/framework/TestHarness'
CommonBehaviors          = require 'test/framework/CommonBehaviors'
ChangeActionOwnerHandler = require 'apps/api/handlers/actions/ChangeActionOwnerHandler'
GetCardQuery             = require 'data/queries/cards/GetCardQuery'

describe 'ChangeActionOwnerHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeActionOwnerHandler)
      @database = TestHarness.getDatabase()
      ready()

  reset = (callback) ->
    TestData.reset ['actions', 'cards', 'notes'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', actionid: 'action-takedbaby'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      payload = {user: 'user-dee'}
      @tester.request {orgid: 'doesnotexist', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->
    it 'returns 404 not found', (done) ->
      payload = {user: 'user-dee'}
      @tester.request {orgid: 'org-paddys', actionid: 'doesnotexist', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid user argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {user: 'doesnotexist'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null user argument', ->
    it 'assigns the action to no one', (done) ->
      payload = {user: null}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.id).to.equal('action-takedbaby')
        expect(action.user).to.equal(null)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid user argument', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    userid   = 'user-dee'

    it 'assigns the action to the specified user', (done) ->
      payload = {user: userid}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.id).to.equal(actionid)
        expect(action.user).to.equal(userid)
        reset(done)

    it 'adds the specified user as a follower of the card', (done) ->
      payload = {user: userid}
      @tester.request {orgid, actionid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        query = new GetCardQuery(action.card)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {card} = result
          expect(card).to.exist()
          expect(card.followers).to.be.an('array')
          expect(card.followers).to.contain(userid)
          reset(done)

#---------------------------------------------------------------------------------------------------
