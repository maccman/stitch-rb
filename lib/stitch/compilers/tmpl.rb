module Stitch
  class TmplCompiler < Compiler
    extensions :tmpl
    
    def compile(path)
      content = File.read(path)
      %{var template = jQuery.template(#{content.to_json});
        module.exports = (function(data){ return jQuery.tmpl(template, data); });}
    end
  end
end