require "erb"

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

        sources.uniq!

        if sources.any?
          stitch(sources)
        end
      end

      def stitch(modules)
        # ERB binding variables
        identifier = @identifier
        modules    = modules

        template = File.read(File.join(File.dirname(__FILE__), "stitch.erb"))
        template = ERB.new(template)
        template.result(binding)
      end
  end
end