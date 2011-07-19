$: << File.join(File.dirname(__FILE__), *%w[.. lib])

require "stitch"

puts Stitch::Package.new(:paths => ["app"], :dependencies => ["lib"]).compile