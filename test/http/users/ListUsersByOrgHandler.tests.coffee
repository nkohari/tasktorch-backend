_                     = require 'lodash'
expect                = require('chai').expect
TestHarness           = require 'test/framework/TestHarness'
ListUsersByOrgHandler = require 'apps/api/handlers/users/ListUsersByOrgHandler'

describe 'users:ListUsersByOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListUsersByOrgHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org with a canceled subscription', ->

    orgid = 'org-oldiesrockcafe'

    it 'returns 402 payment required', (done) ->
      @tester.request {orgid}, (res) ->
        expect(res.statusCode).to.equal(402)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid team in an org of which the requester is a member', ->

    orgid = 'org-paddys'

    it 'returns an array of users that are members of the org', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {users} = res.result
        expect(users).to.exist
        expect(users).to.have.length(5)
        expect(_.pluck(users, 'id')).to.have.members ['user-charlie', 'user-dee', 'user-dennis', 'user-frank', 'user-mac']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a suggest parameter', ->

    orgid = 'org-paddys'
    query = {suggest: 'ma'}

    it 'returns an array of users whose username or name begins with the specified value', (done) ->
      @tester.request {orgid, query}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {users} = res.result
        expect(users).to.exist
        expect(users).to.have.length(3)
        expect(_.pluck(users, 'id')).to.have.members ['user-charlie', 'user-mac', 'user-frank']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid = 'org-sudz'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
