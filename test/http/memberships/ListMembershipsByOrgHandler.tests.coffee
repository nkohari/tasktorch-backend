_                           = require 'lodash'
expect                      = require('chai').expect
TestHarness                 = require 'test/framework/TestHarness'
ListMembershipsByOrgHandler = require 'apps/api/handlers/memberships/ListMembershipsByOrgHandler'

describe 'memberships:ListMembershipsByOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ListMembershipsByOrgHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid = 'org-paddys'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->

    orgid = 'org-paddys'

    it 'returns the list of memberships', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {memberships} = res.result
        expect(memberships).to.have.length(5)
        expect(_.pluck(memberships, 'user')).to.have.members ['user-charlie', 'user-mac', 'user-dennis', 'user-dee', 'user-frank']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid = 'org-sudz'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------
