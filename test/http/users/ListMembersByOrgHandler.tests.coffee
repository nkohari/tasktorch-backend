_                       = require 'lodash'
expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
CommonBehaviors         = require 'test/framework/CommonBehaviors'
ListMembersByOrgHandler = require 'http/handlers/users/ListMembersByOrgHandler'

describe 'ListMembersByOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before ->
    @tester = TestHarness.createTester(ListMembersByOrgHandler)

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid team in an org of which the requester is a member', ->
    it 'returns an array of users that are members of the org', (done) ->
      @tester.request {orgid: 'org-paddys', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {users} = res.body
        expect(users).to.exist()
        expect(users).to.have.length(5)
        expect(_.pluck(users, 'id')).to.have.members ['user-charlie', 'user-dee', 'user-dennis', 'user-frank', 'user-mac']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a suggest parameter', ->
    it 'returns an array of users whose username or name begins with the specified value', (done) ->
      @tester.request {orgid: 'org-paddys', query: {suggest: 'ma'}, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {users} = res.body
        expect(users).to.exist()
        expect(users).to.have.length(2)
        expect(_.pluck(users, 'id')).to.have.members ['user-mac', 'user-frank']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------