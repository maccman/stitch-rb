module Stitch
  class JavaScriptCompiler < Compiler
    extensions :js
    
    def compile(filename)
      File.read(filename)
    end
  end
end