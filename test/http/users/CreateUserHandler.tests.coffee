_                              = require 'lodash'
expect                         = require('chai').expect
TestHarness                    = require 'test/framework/TestHarness'
CreateUserHandler              = require 'apps/api/handlers/users/CreateUserHandler'
GetMembershipByOrgAndUserQuery = require 'data/queries/memberships/GetMembershipByOrgAndUserQuery'
GetInviteQuery                 = require 'data/queries/invites/GetInviteQuery'
GetTokenQuery                  = require 'data/queries/tokens/GetTokenQuery'

describe 'CreateUserHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateUserHandler)
      @database = TestHarness.getDatabase()
      ready()

  afterEach (done) ->
    TestHarness.reset ['invites', 'memberships', 'orgs', 'tokens', 'users'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->

    payload = {
      username: 'waitress'
      password: 'dennis'
      email:    'waitress@coffeeshop.com'
      token:    'token-waitress'
    }

    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a username argument', ->

    payload = {
      name:     'Waitress'
      password: 'dennis'
      email:    'waitress@coffeeshop.com'
      token:    'token-waitress'
    }

    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a password argument', ->

    payload = {
      name:     'Waitress'
      username: 'waitress'
      email:    'waitress@coffeeshop.com'
      token:    'token-waitress'
    }

    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a email argument', ->

    payload = {
      name:     'Waitress'
      username: 'waitress'
      password: 'dennis'
      token:    'token-waitress'
    }

    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a token argument', ->

    payload = {
      name:     'Waitress'
      username: 'waitress'
      password: 'dennis'
      email:    'waitress@coffeeshop.com'
    }

    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid token', ->

    payload = {
      name:     'Rickety Cricket'
      username: 'matthew'
      password: 'sweetdee'
      email:    'rickety.cricket@underthebridge.com'
      token:    'token-ricketycricket'
    }

    it 'creates and returns the user', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        expect(user).to.exist()
        expect(user.name).to.equal(payload.name)
        expect(user.username).to.equal(payload.username)
        done()

    it 'marks the token as accepted', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetTokenQuery(payload.token)
        @database.execute query, (err, result) =>
          expect(err).to.not.exist()
          expect(result.token).to.exist()
          expect(result.token.status).to.equal('Accepted')
          done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid invite', ->

    payload = {
      name:     'Waitress'
      username: 'waitress'
      password: 'dennis'
      email:    'waitress@coffeeshop.com'
      invite:   'invite-waitress'
    }

    it 'creates and returns the user', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        expect(user).to.exist()
        expect(user.name).to.equal(payload.name)
        expect(user.username).to.equal(payload.username)
        done()

    it 'marks the invite as accepted', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        query = new GetInviteQuery(payload.invite)
        @database.execute query, (err, result) =>
          expect(err).to.not.exist()
          expect(result.invite).to.exist()
          expect(result.invite.status).to.equal('Accepted')
          done()

    it 'adds the user to the org associated with the token', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {user} = res.result
        query = new GetMembershipByOrgAndUserQuery('org-paddys', user.id)
        @database.execute query, (err, result) =>
          expect(err).to.not.exist()
          console.log(result)
          expect(result.membership).to.exist()
          expect(result.membership.org).to.equal('org-paddys')
          expect(result.membership.user).to.equal(user.id)
          done()

#---------------------------------------------------------------------------------------------------
