var ORM = require('models/orm');

var User = function(name){
  this.name = name;
};

User.ORM = ORM;

module.exports = User;