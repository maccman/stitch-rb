module Stitch
  class MustacheCompiler < Compiler
    extensions :mustache

    def compile(path)
      content = File.read(path)
      %{var template = #{content.to_json};
        module.exports = (function(view){ return Mustache.to_html(template, view); });}
    end
  end
end