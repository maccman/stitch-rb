
(function(/*! Stitch !*/) {
  if (!this.require) {
    var modules = {}, cache = {};
    var require = function(name, root) {
      var path = expand(root, name), indexPath = expand(path, './index'), module, fn;
      module   = cache[path] || cache[indexPath];
      if (module) {
        return module;
      } else if (fn = modules[path] || modules[path = indexPath]) {
        module = {id: path, exports: {}};
        cache[path] = module.exports;
        fn(module.exports, function(name) {
          return require(name, dirname(path));
        }, module);
        return cache[path] = module.exports;
      } else {
        throw 'module ' + name + ' not found';
      }
    };
    var expand = function(root, name) {
      var results = [], parts, part;
      // If path is relative
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    };
    var dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    };
    this.require.define = function(bundle) {
      for (var key in bundle) {
        modules[key] = bundle[key];
      }
    };
    this.require.modules = modules;
    this.require.cache   = cache;
  }
  return this.require.define;
}).call(this)({
  "models/orm": function(exports, require, module) {
module.exports = {orm: true};

window.ormCount = window.ormCount || 0;
window.ormCount += 1;
}, "models/user": function(exports, require, module) {
var ORM = require('models/orm');

var User = function(name){
  this.name = name;
};

User.ORM = ORM;

module.exports = User;
}, "models/person": function(exports, require, module) {
var ORM = require('models/orm');
}, "index": function(exports, require, module) {
require('models/user');
require('models/person');

// Do some stuff
}
});