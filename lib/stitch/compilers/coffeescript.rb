module Stitch
  class CoffeeScriptCompiler < Compiler
    extensions :cs, :coffee
    
    enabled begin
      require "coffee-script"
    rescue LoadError
      false
    end
    
    def compile(path)
      source = File.read(path)
      CoffeeScript.compile(source)
    end
  end
end