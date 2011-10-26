vows = require 'vows'
assert = require 'assert'

main = require '../lib/index'
specHelper = require './spec_helper'

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
    "WHEN creating a client": 
      topic:  () ->
        client = specHelper.createClient()
        client
      "THEN the client must exist": (client) ->
        assert.isNotNull client 
      "THEN it's key must be set": (client) ->
        assert.equal client.key,specHelper.key
      "THEN it's secret must be set": (client) ->
        assert.equal client.secret,specHelper.secret
      "THEN it's scope must be set": (client) ->
        assert.equal client.scope,"read write"
        
  .addBatch 
    "WHEN authenticating with valid credentials": 
      topic:  () ->
        client = specHelper.createClient()
        client.authenticate(specHelper.username,specHelper.password,@callback)
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err 
      "THEN it's data must contain a token": (err,data) ->
        assert.equal data.access_token,specHelper.resultToken 
      "THEN it's data must contain a scope": (err,data) ->
        assert.equal data.scope,"read write"

  .export module
