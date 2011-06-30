module Stitch
  class JavaScriptCompiler < Compiler
    extensions :js
    
    def compile(path)
      File.read(path)
    end
  end
end