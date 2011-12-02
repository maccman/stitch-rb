module Stitch
  class Package
    DEFAULTS = {
      :identifier   => "require",
      :paths        => [],
      :files        => [],
      :dependencies => []
    }

    def initialize(options = {})
      options = DEFAULTS.merge(options)

      @identifier   = options[:identifier]
      @paths        = Array(options[:paths])
      @files        = Array(options[:files])
      @root         = options[:root]
      @dependencies = Array(options[:dependencies])
    end

    def compile
      [compile_dependencies, compile_sources].join("\n")
    end

    protected
      def compile_dependencies
        @dependencies.map {|path|
          Source.from_path(path)
        }.flatten.map { |dep|
          dep.compile
        }.join("\n")
      end

      def compile_sources
        sources = @paths.map {|path|
          Source.from_path(path)
        }.flatten

        sources |= @files.map {|file|
          Source.from_file(@root, file)
        }.flatten

        if sources.any?
          stitch(sources)
        end
      end

      def stitch(sources)
        result = <<-EOF
(function(/*! Stitch !*/) {
  if (!this.#{@identifier}) {
    var modules = {}, cache = {}, require = function(name, root) {
      var module = cache[name], path = expand(root, name), fn;
      if (module) {
        return module;
      } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
        module = {id: name, exports: {}};
        try {
          cache[name] = module.exports;
          fn(module.exports, function(name) {
            return require(name, dirname(path));
          }, module);
          return cache[name] = module.exports;
        } catch (err) {
          delete cache[name];
          throw err;
        }
      } else {
        throw 'module \\'' + name + '\\' not found';
      }
    }, expand = function(root, name) {
      var results = [], parts, part;
      if (/^\\.\\.?(\\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    }, dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.#{@identifier} = function(name) {
      return require(name, '');
    }
    this.#{@identifier}.define = function(bundle) {
      for (var key in bundle)
        modules[key] = bundle[key];
    };
  }
  return this.#{@identifier}.define;
}).call(this)({
        EOF
        sources.each_with_index do |source, i|
          result += i == 0 ? "" : ", "
          result += source.name.to_json
          result += ": function(exports, require, module) {\n#{source.compile}\n}"
        end

        result += "});\n"
      end
  end
end