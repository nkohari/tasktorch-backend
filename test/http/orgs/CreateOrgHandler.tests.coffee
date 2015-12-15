_                             = require 'lodash'
expect                        = require('chai').expect
TestHarness                   = require 'test/framework/TestHarness'
CreateOrgHandler              = require 'apps/api/handlers/orgs/CreateOrgHandler'
GetAllKindsByOrgQuery         = require 'data/queries/kinds/GetAllKindsByOrgQuery'
GetAllMembershipsByOrgQuery   = require 'data/queries/memberships/GetAllMembershipsByOrgQuery'
GetAllStacksByOrgAndUserQuery = require 'data/queries/stacks/GetAllStacksByOrgAndUserQuery'

describe 'orgs:CreateOrgHandler', ->

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

  describe 'when called with valid arguments', ->

    payload = {name: new Date().valueOf().toString(), survey}

    it 'creates and returns the org', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {org} = res.result
        expect(org).to.exist
        expect(org.name).to.equal(payload.name)
        done()

    it 'creates a default kind for the org', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {org} = res.result
        query = new GetAllKindsByOrgQuery(org.id)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          {kinds} = result
          expect(kinds).to.have.length(1)
          expect(_.first(kinds).name).to.equal('Task')
          done()

    it 'creates default stacks for the requester', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {org} = res.result
        query = new GetAllStacksByOrgAndUserQuery(org.id, 'user-charlie')
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          {stacks} = result
          expect(stacks).to.have.length(2)
          expect(_.any(stacks, (s) -> s.type == 'Inbox'))
          expect(_.any(stacks, (s) -> s.type == 'Queue'))
          done()

    it 'adds the requester as a member', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {org} = res.result
        query = new GetAllMembershipsByOrgQuery(org.id)
        @database.execute query, (err, result) =>
          expect(err).not.to.exist
          expect(result).to.exist
          {memberships} = result
          expect(memberships).to.have.length(1)
          expect(_.first(memberships).user).to.equal('user-charlie')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an email argument', ->

    payload = {name: new Date().valueOf().toString(), survey, email: 'catenthusiast@kittenmittons.com'}

    it 'sets the org email to the specified email', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {org} = res.result
        expect(org).to.exist
        expect(org.email).to.equal(payload.email)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without an email argument', ->

    payload = {name: new Date().valueOf().toString(), survey}

    it 'sets the org email to the email of the requester', (done) ->
      @tester.request {payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {org} = res.result
        expect(org).to.exist
        expect(org.email).to.equal(@tester.credentials.user.email)
        done()

#---------------------------------------------------------------------------------------------------
