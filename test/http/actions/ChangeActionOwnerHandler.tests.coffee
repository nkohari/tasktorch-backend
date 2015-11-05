expect                   = require('chai').expect
TestHarness              = require 'test/framework/TestHarness'
ChangeActionOwnerHandler = require 'apps/api/handlers/actions/ChangeActionOwnerHandler'
GetCardQuery             = require 'data/queries/cards/GetCardQuery'

describe 'actions:ChangeActionOwnerHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeActionOwnerHandler, 'user-charlie')
      @database = TestHarness.getDatabase()
      ready()

  afterEach (done) ->
    TestHarness.reset ['actions', 'cards', 'notes'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid    = 'doesnotexist'
    actionid = 'action-takedbaby'
    payload  = {user: 'user-dee'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->

    orgid    = 'org-paddys'
    actionid = 'doesnotexist'
    payload  = {user: 'user-dee'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid user argument', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {user: 'doesnotexist'}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null user argument', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {user: null}

    it 'assigns the action to no one', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {action} = res.result
        expect(action.id).to.equal(actionid)
        expect(action.user).to.equal(null)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid user argument', ->

    orgid    = 'org-paddys'
    actionid = 'action-takedbaby'
    payload  = {user: 'user-dee'}

    it 'assigns the action to the specified user', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {action} = res.result
        expect(action.id).to.equal(actionid)
        expect(action.user).to.equal(payload.user)
        done()

    it 'adds the specified user as a follower of the card', (done) ->
      @tester.request {orgid, actionid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {action} = res.result
        query = new GetCardQuery(action.card)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          {card} = result
          expect(card).to.exist
          expect(card.followers).to.be.an('array')
          expect(card.followers).to.contain(payload.user)
          done()

#---------------------------------------------------------------------------------------------------
