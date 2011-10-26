main = require '../lib/index'
fs = require 'fs'
nock = require 'nock'

module.exports = 
  nocked: null

  #* We need mocking support, which requires no https for now.
  requestUrl : "http://api.scottyapp.com"

  # The following tokens are just random, request your own at http://scottyapp.com/developers
  key : "aea27b3dbab23e0001000002"
  secret: "62eba4683b5c1b014b114463afed70f036dbeea6951b092346b6b58ddfff524f"
  username: "foo"
  password: "bar"
  resultToken: "234190d7302a42eb96292c84d175a5a6823ecd866296ecd6792256765702cc78"
  
  createClient: ->
    client = new main.Client(@key,@secret)
    client.baseUrl = @requestUrl
    client
    
  setup: (cb) ->
    @nocked = nock(@requestUrl) 
                .post('/oauth/access_token',"grant_type=password&client_id=aea27b3dbab23e0001000002&client_secret=62eba4683b5c1b014b114463afed70f036dbeea6951b092346b6b58ddfff524f&scope=read%20write&username=foo&password=bar")
                .replyWithFile(200,@fixturePath("valid_auth.json"))
                #.get(@notFoundPath)
                #.replyWithFile(404,"#{__dirname}/fixtures/notfound.txt")

    cb null
    
  fixturePath: (fileName) ->
    "#{__dirname}/fixtures/#{fileName}"

  tmpPath: (fileName) ->
    "#{__dirname}/../tmp/#{fileName}"

  cleanTmpFiles: (fileNames) ->
    for file in fileNames
      try
        fs.unlinkSync @tmpPath(file)
      catch ignore

  loadJsonFixture: (fixtureName) ->
    data = fs.readFileSync @fixturePath(fixtureName), "utf-8"
    JSON.parse data
    
