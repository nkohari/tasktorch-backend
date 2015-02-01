expect                   = require('chai').expect
TestData                 = require 'test/framework/TestData'
TestHarness              = require 'test/framework/TestHarness'
CommonBehaviors          = require 'test/framework/CommonBehaviors'
ChangeActionOwnerHandler = require 'http/handlers/actions/ChangeActionOwnerHandler'

describe 'ChangeActionOwnerHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeActionOwnerHandler)
      ready()

  afterEach (done) ->
    TestData.reset ['actions'], done

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
        expect(res.body).to.exist()
        {action} = res.body
        expect(action.id).to.equal('action-takedbaby')
        expect(action.owner).to.equal(null)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid user argument', ->
    it 'assigns the action to the specified user', (done) ->
      payload = {user: 'user-dee'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {action} = res.body
        expect(action.id).to.equal('action-takedbaby')
        expect(action.owner).to.equal('user-dee')
        done()

#---------------------------------------------------------------------------------------------------
