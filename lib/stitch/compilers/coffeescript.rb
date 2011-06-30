module Stitch
  class CoffeeScriptCompiler < Compiler
    extensions :cs, :coffee
    
    enabled begin
      require "coffee-script"
    rescue LoadError
      false
    end
    
    def compile(filename)
      source   = File.read(filename)
      CoffeeScript.compile(source)
    end
  end
end