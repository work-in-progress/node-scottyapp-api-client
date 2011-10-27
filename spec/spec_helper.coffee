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
                .get('/v1/info',"")
                .replyWithFile(200,@fixturePath("info.json"))
                .get('/v1/me',"")
                .replyWithFile(200,@fixturePath("me.json"))
                .put('/v1/me',"")
                .replyWithFile(200,@fixturePath("me_put.json"))
                .post('/v1/users',"")
                .replyWithFile(200,@fixturePath("users_post.json"))
                .put('/v1/users/martin_sunset',"")
                .replyWithFile(200,@fixturePath("users_put.json"))
                .get('/v1/users/martin_sunset/organizations',"")
                .replyWithFile(200,@fixturePath("users_organizations.json"))
                .get('/v1/organizations',"")
                .replyWithFile(200,@fixturePath("organizations.json"))
                .get('/v1/organizations/ohmyg',"")
                .replyWithFile(200,@fixturePath("organizations_get.json"))
                .put('/v1/organizations/martin_sunset',"")
                .replyWithFile(200,@fixturePath("organizations_put.json"))
                .post('/v1/organizations',"")
                .replyWithFile(200,@fixturePath("organizations_post.json"))
                .delete('/v1/organizations/martin_sunset',"")
                .replyWithFile(200,@fixturePath("organizations_delete.json"))
                .post('/v1/organizations/martin_sunset/apps',"")
                .replyWithFile(200,@fixturePath("organizations_apps_post.json"))
                .get('/v1/organizations/martin_sunset/apps',"")
                .replyWithFile(200,@fixturePath("organizations_apps.json"))
                .get('/v1/organizations/martin_sunset/apps/app1',"")
                .replyWithFile(200,@fixturePath("organizations_apps_get.json"))
                .put('/v1/organizations/martin_sunset/apps/app1',"")
                .replyWithFile(200,@fixturePath("organizations_apps_put.json"))
                .delete('/v1/organizations/martin_sunset/apps/app1',"")
                .replyWithFile(200,@fixturePath("organizations_apps_delete.json"))



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
    
