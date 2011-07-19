require "json"
require "stitch/version"

module Stitch
  autoload :Compiler,   "stitch/compiler"
  autoload :Package,    "stitch/package"
  autoload :Dependency, "stitch/dependency"
  autoload :Source,     "stitch/source"
  autoload :Server,     "stitch/server"
end