_                   = require 'lodash'
expect              = require('chai').expect
TestHarness         = require 'test/framework/TestHarness'
CommonBehaviors     = require 'test/framework/CommonBehaviors'
ListMyStacksHandler = require 'http/handlers/me/ListMyStacksHandler'

describe 'ListMyStacksHandler', ->

#---------------------------------------------------------------------------------------------------

  before ->
    @tester = TestHarness.createTester(ListMyStacksHandler)

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is a member', ->
    it 'returns an array of stacks owned by the requester in that org', (done) ->
      @tester.request {orgid: 'org-paddys', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {stacks} = res.body
        expect(stacks).to.be.an('array')
        expect(stacks).to.have.length(3)
        expect(_.pluck(stacks, 'id')).to.have.members ['stack-charlie-inbox', 'stack-charlie-queue', 'stack-charlie-drafts']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------