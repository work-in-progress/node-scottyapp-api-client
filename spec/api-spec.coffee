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

  .export module
