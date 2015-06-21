_                     = require 'lodash'
expect                = require('chai').expect
StackType             = require 'data/enums/StackType'
TestHarness           = require 'test/framework/TestHarness'
CommonBehaviors       = require 'test/framework/CommonBehaviors'
GetQueueByUserHandler = require 'apps/api/handlers/stacks/GetQueueByUserHandler'

describe 'GetQueueByUserHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetQueueByUserHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', userid: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', userid: 'user-charlie', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent user', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', userid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid user in an org of which the requester is a member', ->
    it "returns the user's queue stack for that org", (done) ->
      @tester.request {orgid: 'org-paddys', userid: 'user-charlie', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {stack} = res.result
        expect(stack).to.exist()
        expect(stack.type).to.equal(StackType.Queue)
        expect(stack.org).to.equal('org-paddys')
        expect(stack.user).to.equal('user-charlie')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', userid: 'user-greg', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and userid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', userid: 'user-greg', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
