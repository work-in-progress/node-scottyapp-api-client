xhr = require 'request'
qs  = require 'querystring'

###*
The client class used to connect with scottyapp.com
###
class exports.Client
  
  ###*
  The base url of the web service. Exposed for testing against local install.
  ###
  baseUrl : "https://api.scottyapp.com"
  versionPath: "/v1"
  
  ###*
  Initializes a new instance of @see Client
  @param (String) key the api key obtained from scottyapp.com/developers
  @param (String) secret the api secret
  @param (String) scope defaults to "read write".
  ###
  constructor: (@key,@secret,@scope = "read write") ->
    throw new Error("You need to pass a key and secret") unless @key && @secret
  
  # Sets the access token that was obtained through the oauth2 dance
  # Use this method or @see authenticate.
  setAccessToken: (@accessToken) ->
    
  ###*
  Authenticates against the API using username and password. 
  This is not a recommended way that only makes sense in 
  scenarios like command line utilities. 
  @example
  curl -i https://api.scottyapp.com/oauth/access_token \
    -F grant_type=password \
    -F client_id=key \
    -F client_secret=secret \
    -F "scope=read write" \
    -F username=username \
    -F password=password
  =>
  {"access_token":"b34190d7302a42eb96292c84d175a5a6","scope": "read write"}
  ###
  authenticate : (username,password,cb) ->
    data = {}
    data.grant_type = 'password'
    data.client_id = @key
    data.client_secret = @secret
    data.scope = @scope
    data.username = username
    data.password = password
    
    url = "#{@baseUrl}/oauth/access_token"
    @_postAsForm url,data, (err,payload,request,body) =>
      @accessToken = null #* ensure that it is cleaned up, regardless what happened
      return cb(err,null,request,body) if err
      @accessToken = payload['access_token']
      cb err,payload,request,body
  
  me: (cb) ->
    url = "#{@baseUrl}#{@versionPath}/me"
    @_get url,cb
    
  updateMe: (data,cb) ->
    url = "#{@baseUrl}#{@versionPath}/me"
    @_put url,data,cb
  
  createUser: (username,password,email,cb) ->
    data =
      username : username
      password : password
      email : email
    
    url = "#{@baseUrl}#{@versionPath}/users"
    @_post url,data,cb
    
  updateUser:(username,data,cb) ->
    url = "#{@baseUrl}#{@versionPath}/users/#{username}"
    @_put url,data,cb
  
  organizationsForUser:(username,cb) ->
    url = "#{@baseUrl}#{@versionPath}/users/#{username}/organizations"
    @_get url,cb
    
  organizations: (cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations"
    @_get url,cb
    
  organization: (name,cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations/#{name}"
    @_get url,cb
    
  updateOrganization: (name,data,cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations/#{name}"
    @_put url,data,cb
  
  createOrganization: (name,data,cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations"
    data.name = name if name
    @_post url,data,cb
  
  deleteOrganization: (name,cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations/#{name}"
    @_delete url,cb
    
  ###*
  Retrieve the apps for an organization (a user is always it's own organization)
  @example
  curl http://192.168.1.101:3000/v1/organizations/username/apps
  =>
  {"total_count":4,"request_id":"","offset":0,"count":30,"collection":[{"_id":"4e2e746fc2db19107c000006","description":"first project 1","name":"test","slug":"test"},{"_id":"4e3bb63ac2db194f2b000002","description":"Martins test project","name":"test 1","slug":"test-1"},{"_id":"4e3bd46cc2db194f2b00000a","description":"test3","name":"test3","slug":"test3"},{"_id":"4e3cf2edc2db1953c2000002","description":"test4","name":"test4","slug":"test4"}]}
  ###
  appsForOrganization: (organizationName,cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations/#{organizationName}/apps"
    @_get url,cb
  
  ###*
  #curl http://192.168.1.101:3000/v1/organizations/martin_sunset/apps -X POST  -H "Authorization: OAuth 22041c80355ec10b82d8aebcd2f8debd0b77b6ff54567fd4e285a722b1ef1e7a" \
  #-F name=testapp \
  #-F description=blah
  curl http://192.168.1.101:3000/v1/organizations/martin_sunset/apps -X POST  -H "Authorization: OAuth 22041c80355ec10b82d8aebcd2f8debd0b77b6ff54567fd4e285a722b1ef1e7a" \
  -d '{"name":"anew app","description": "blah"}' 
  =>

  ###
  createApp: (organizationOrUsername,name,description,isPrivate = false,cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations/#{organizationOrUsername}/apps"
    
    @_post url,{name,description,isPrivate},cb

  app: (organizationName,appName,cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations/#{organizationName}/apps/#{appName}"
    @_get url,cb
    
  updateApp: (organizationName,appName,data,cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations/#{organizationName}/apps/#{appName}"
    @_put url,data,cb
  
  deleteApp: (organizationName,appName,cb) ->
    url = "#{@baseUrl}#{@versionPath}/organizations/#{organizationName}/apps/#{appName}"
    @_delete url,cb

  ###*
  Returns infos about the API. 
  @example
  curl https://api.scottyapp.com/v1/info
  =>
  {"name":"scottyapp","canonicalUrl" : "https://api.scottyapp.com/v1","version" : 1}
  ###
  info: (cb) ->
    url = "#{@baseUrl}#{@versionPath}/info"
    @_get url,cb
    
  

  
  ###
  # The following two methods curtesy of 
  # https://github.com/meritt/node-tumblr/blob/master/src/tumblr.coffee
  #
  # Prepare url for API call
  urlFor : (action, self, options = null) ->
    params = [
      @baseUrl
      self.host + '/' + action                 # blog host and action
      '/' + options.type if options?.type?     # optional type of post to return
      '?api_key=' + self.key                   # API key
    ]

    delete options.type if options?.type?

    query = qs.stringify options
    params.push '&' + query if query isnt ''   # optional params

    params.join ''
  ###

  # Request API and call callback function with response
  _get : (url, fn = ->) ->
    @_request(url,"GET",null,null,fn)
  
  _postAsForm : (url,payload, fn = ->) ->
    @_request(url,"POST",payload,postAsForm:true,fn)
  
  _post : (url,payload, fn = ->) ->
    @_request(url,"POST",payload,null,fn)

  _put : (url,payload, fn = ->) ->
    @_request(url,"PUT",payload,null,fn)

  _delete : (url, fn = ->) ->
    @_request(url,"DELETE",null,null,fn)

  _request : (url,method = "GET",payload,options, fn = ->) ->
    #console.log "URL: #{url}"
    headers = 
      'Content-Type': 'application/x-www-form-urlencoded'
    headers['Authorization'] = "OAuth #{@acccessToken}" if @accessToken

    options = {} unless options
    postAsForm = !!options.postAsForm
    
    #console.log payload
    body = null    
    body = qs.stringify( payload) if payload && postAsForm
    body = JSON.stringify( payload) if payload && !postAsForm
    #console.log postAsForm 
    #console.log body
    
    xhr 
      url: url
      method: method
      body: body
      headers: headers
      , (error, request, body) ->
        return fn(error,null,request,body) if error
        console.log body
        fn null,JSON.parse(body),request,body

