_                     = require 'lodash'
expect                = require('chai').expect
StackType             = require 'data/enums/StackType'
TestHarness           = require 'test/framework/TestHarness'
GetQueueByUserHandler = require 'apps/api/handlers/stacks/GetQueueByUserHandler'

describe 'stacks:GetQueueByUserHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetQueueByUserHandler, 'user-charlie')
      ready()

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid  = 'org-paddys'
    userid = 'user-charlie'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, userid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid  = 'doesnotexist'
    userid = 'user-charlie'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, userid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent user', ->

    orgid  = 'org-paddys'
    userid = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, userid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid user in an org of which the requester is a member', ->

    orgid  = 'org-paddys'
    userid = 'user-charlie'

    it "returns the user's queue stack for that org", (done) ->
      @tester.request {orgid, userid}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {stack} = res.result
        expect(stack).to.exist
        expect(stack.type).to.equal(StackType.Queue)
        expect(stack.org).to.equal(orgid)
        expect(stack.user).to.equal(userid)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid  = 'org-sudz'
    userid = 'user-greg'

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, userid}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and userid', ->

    orgid  = 'org-paddys'
    userid = 'user-greg'

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, userid}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
