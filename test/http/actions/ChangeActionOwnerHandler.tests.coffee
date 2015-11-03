expect                   = require('chai').expect
TestData                 = require 'test/framework/TestData'
TestHarness              = require 'test/framework/TestHarness'
ChangeActionOwnerHandler = require 'apps/api/handlers/actions/ChangeActionOwnerHandler'
GetCardQuery             = require 'data/queries/cards/GetCardQuery'

describe 'ChangeActionOwnerHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeActionOwnerHandler)
      @tester.impersonate('user-charlie')
      @database = TestHarness.getDatabase()
      ready()

  afterEach (done) ->
    TestData.reset ['actions', 'cards', 'notes'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->
    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid: 'org-paddys', credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      payload = {user: 'user-dee'}
      @tester.request {orgid: 'doesnotexist', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->
    it 'returns 404 not found', (done) ->
      payload = {user: 'user-dee'}
      @tester.request {orgid: 'org-paddys', actionid: 'doesnotexist', payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid user argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {user: 'doesnotexist'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null user argument', ->
    it 'assigns the action to no one', (done) ->
      payload = {user: null}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.id).to.equal('action-takedbaby')
        expect(action.user).to.equal(null)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid user argument', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    userid   = 'user-dee'

    it 'assigns the action to the specified user', (done) ->
      payload = {user: userid}
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.id).to.equal(actionid)
        expect(action.user).to.equal(userid)
        done()

    it 'adds the specified user as a follower of the card', (done) ->
      payload = {user: userid}
      @tester.request {orgid, actionid, payload}, (res) =>
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
          done()

#---------------------------------------------------------------------------------------------------
