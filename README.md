# Stitch

This is a port of Sam Stephenson's [Stich](https://github.com/sstephenson/stitch) to Ruby. Stitch allows you to:

> Develop and test your JavaScript applications as CommonJS modules in Node.js. Then __Stitch__ them together to run in the browser.

In other words, this is a [CommonJS](http://dailyjs.com/2010/10/18/modules/) JavaScript package management solution. It's terribly simple, bundling up all your applications JavaScript files without intelligently resolving dependencies. However, unless your application is very modular, it turns out thats all you need.

##Usage

Install the gem, or add it to your Gemfile:
  
    gem 'stitch-rb'

You can compile your application like this:

    Stitch::Package.new(:paths => ["app"], :dependencies => ["lib/jquery.js"]).compile
    
It returns a JavaScript file that you can serve to your users, or write to disk and cache.

You should give `Stitch::Package` an array of `:paths`, the relative directories your JavaScript application is served from. You can also specify an array of `:dependencies`, JavaScript files which will be concatenated without being wrapped in CommonJS modules. 

##Rails & Rack

Stitch includes a basic Rack server, for example this is how you'd use it with Rails 3 routes:

    match '/application.js' => Stitch::Server.new(:paths => ["app/assets/javascripts"])

##Adding compilers

Compilers need to inherit from `Stitch::Compiler`. They're very simple, for example:

    class jQueryTmplCompiler < Stitch::Compiler
      # List of supported extensions
      extensions :tmpl
    
      # A compile method which takes a file path, 
      # and returns a compiled string
      def compile(path)
        content = File.read(path)
        %{
          var template = jQuery.template(#{content.to_json});
          module.exports = (function(data){ return jQuery.tmpl(template, data); });
        }
      end
    end