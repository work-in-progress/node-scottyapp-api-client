(function() {
  /**
  Parts modeled after Nodejitsu's jitsu
  */  require('pkginfo')(module, 'version');
  exports.Client = require('./client').Client;
}).call(this);
