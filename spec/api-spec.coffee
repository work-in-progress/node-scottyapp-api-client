vows = require 'vows'
assert = require 'assert'

main = require '../lib/index'
specHelper = require './spec_helper'
client = specHelper.createClient()
client.setAccessToken(specHelper.resultToken)

vows.describe("auth")
  .addBatch
    "CLEANUP TEMP":
      topic: () ->
        specHelper.cleanTmpFiles []
      "THEN IT SHOULD BE CLEAN :)": () ->
        assert.isTrue true        
  .addBatch
    "SETUP" :
      topic: () -> 
        specHelper.setup @callback
        return
      "THEN IT SHOULD BE SET UP :)": () ->
        assert.isTrue true
  .addBatch 
    "WHEN calling me - GET /v1/me": 
      topic:  () ->
        client.me(@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
      "THEN it's data must contain a user name": (err,data) ->
        assert.equal data.user_name,"martin_sunset"
  .addBatch 
    "WHEN calling updateMe - PUT /v1/me": 
      topic:  () ->
        client.updateMe({"twitter_name" : "martin_sunset2"},@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
      "THEN it's data must contain a user name": (err,data) ->
        assert.equal data.user_name,"martin_sunset"
      "THEN it's data must contain a twitter_name": (err,data) ->
        assert.equal data.twitter_name,"martin_sunset2"
  .addBatch 
    "WHEN calling createUser - POST /v1/users": 
      topic:  () ->
        client.createUser("ohmyg","apassword12","kim@kardashian.com",@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
  .addBatch 
    "WHEN calling updateUser - PUT /v1/users/martin_sunset": 
      topic:  () ->
        client.updateUser("martin_sunset",{"twitter_name" : "martin_sunset"},@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
  .addBatch 
    "WHEN calling organizationsForUser - GET /v1/users/martin_sunset/organizations": 
      topic:  () ->
        client.organizationsForUser("martin_sunset",@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
  .addBatch 
    "WHEN calling organizations - GET /v1/organizations": 
      topic:  () ->
        client.organizations(@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
  .addBatch 
    "WHEN calling organization - GET /v1/organizations/martin_sunset": 
      topic:  () ->
        client.organization("martin_sunset",@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
  .addBatch 
    "WHEN calling updateOrganization - PUT /v1/organizations/martin_sunset": 
      topic:  () ->
        client.updateOrganization("martin_sunset",{"description" : "A nice description"},@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
  .addBatch 
    "WHEN calling createOrganization - POST /v1/organizations": 
      topic:  () ->
        client.createOrganization("org2",{"description" : "Another organization"},@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
  .addBatch 
    "WHEN calling deleteOrganization - DELETE /v1/organizations/org2": 
      topic:  () ->
        client.deleteOrganization("org2",@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
        

  .export module
