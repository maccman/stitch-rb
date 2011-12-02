module Stitch
  class JavaScriptCompiler < Compiler
    extensions :js

    source true

    def compile(path)
      File.read(path)
    end
  end
end