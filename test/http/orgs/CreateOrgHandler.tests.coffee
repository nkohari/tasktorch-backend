_                = require 'lodash'
expect           = require('chai').expect
TestHarness      = require 'test/framework/TestHarness'
CreateOrgHandler = require 'apps/api/handlers/orgs/CreateOrgHandler'

describe 'CreateOrgHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateOrgHandler, 'user-charlie')
      @database = TestHarness.getDatabase()
      ready()

  afterEach (done) ->
    TestHarness.reset ['memberships', 'orgs', 'stacks'], done

  survey = {size: 'xs', tsp: 'xs', role: 'employee'}

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    it 'returns 401 unauthorized', (done) ->
      @tester.request {credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a name argument', ->

    payload = {survey}

    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a survey argument', ->

    payload = {name: 'Test'}

    it 'returns 400 bad request', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with valid name and survey arguments, and no email argument', ->

    payload = {name: new Date().valueOf().toString(), survey}

    it 'creates and returns the org', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {org} = res.result
        expect(org).to.exist()
        expect(org.name).to.equal(payload.name)
        done()

    it 'adds the requester as a member', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {org} = res.result
        query = new GetAllMembershipsByOrgQuery(org.id)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist()
          expect(result).to.exist()
          {memberships} = result
          expect(memberships).to.have.length(1)
          expect(_.first(memberships[0]).user).to.equal('user-charlie')
        done()

    it 'sets the org email to the email of the requester', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {org} = res.result
        expect(org).to.exist()
        expect(org.email).to.equal(@tester.credentials.user.email)
        done()

#---------------------------------------------------------------------------------------------------
