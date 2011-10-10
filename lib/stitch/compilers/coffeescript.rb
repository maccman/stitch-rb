module Stitch
  class CoffeeScriptCompiler < Compiler
    extensions :cs, :coffee
    
    enabled begin
      require "coffee-script"
      true
    rescue LoadError
      false
    end
    
    def compile(path)
      source = File.read(path)
      CoffeeScript.compile(source)
    rescue => e
      raise RuntimeError, "#{path}: #{e}", ''
    end
  end
end