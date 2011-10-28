## About node-scottyapp-api-client

Official node.js API client for scottyapp.com. Documentation will be made available at http://scottyapp.com/developers


[![Build Status](https://secure.travis-ci.org/scottyapp/node-scottyapp-api-client.png)](http://travis-ci.org/scottyapp/node-scottyapp-api-client.png)

# Install

npm install scottyapp-api-client

## Usage

Take a look at the https://github.com/scottyapp/scotty project and the tests included here.

### Coffeescript

	Client = require('scottyapp-api-client').Client
	client = new Client('yourkey','yoursecret')
	client.doStuff(...)

### Javascript

	var Client = require('scottyapp-api-client').Client;
	var client = new Client('yourkey','yoursecret');
	client.doStuff(...);

## About Us


Check out 

* http://scottyapp.com

Follow us on Twitter at 

* @getscottyapp

and like us on Facebook please. Every mention is welcome and we follow back.

## Release Notes

### 0.0.3

* Fixed an even more pathetic token bug

### 0.0.2

* Fixed some pathetic token bug. 

### 0.0.1

* First version - basic api done.

## Internal Stuff

* npm run-script watch

# Publish new version

* Change version in package.json
* git tag -a v0.0.3 -m 'version 0.0.3'
* git push --tags
* npm publish

## Copyright

Copyright (c) 2011 Martin Wawrusch and Freshfugu, Inc. See LICENSE for
further details.


