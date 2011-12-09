require "pathname"

module Stitch
  class Source
    # Recursively load all the sources from a given directory
    # Usage:
    #   sources = Source.from_path("./app")
    #
    def self.from_path(root, path = nil, result = [])
      path ||= root
      path = Pathname.new(path)

      if path.directory?
        path.children.each do |child|
          from_path(root, child, result)
        end
      else
        source = self.new(root, path)
        result << source if source.valid?
      end
      result
    end

    # Recursively resolve sources from a given file,
    # dynamically resolving its dependencies
    # Usage:
    #   sources = Source.from_file("./app/index.js")
    #
    def self.from_file(root, path = nil, result = [])
      root = Pathname.new(root)

      unless path
        path = root
        root = root.dirname
      end

      source = self.new(root, path)
      source.requires.each do |child|
        from_file(root, child, result)
      end

      result << source
    end

    # Resolve a require call to an absolute path
    # Usage:
    #   path = Source.resolve("../index.js", "/my/file.js")
    #
    def self.resolve(path, relative_to)
      path        = Pathname.new(path)
      relative_to = Pathname.new(relative_to)

      unless path.absolute?
        path = path.expand_path(relative_to)
      end

      return path if path.exist?

      Compiler.all_extensions.each do |ext|
        candidate = Pathname.new(path.to_s + "." + ext)
        return candidate if candidate.exist?
      end

      raise "#{path} not found"
    end

    attr_reader :root, :path

    def initialize(root, path)
      @root = Pathname.new(root).expand_path
      @path = Pathname.new(path).expand_path
    end

    def name
      name = path.relative_path_from(root)
      name = name.dirname + name.basename(".*")
      name.to_s
    end

    def ext
      path.extname
    end

    def compile
      compiler.compile(path)
    end

    def valid?
      !!compiler
    end

    # Return an array of resolved paths
    # specifying this source's dependencies
    def requires
      return [] unless source?
      requires = path.read.scan(/require\(("|')(.+)\1\)/)
      requires.map {|(_, pn)| self.class.resolve(pn, root) }
    end

    def hash
      self.path.hash
    end

    def eql?(source)
      source.is_a?(Source) &&
        source.path.to_s == self.path.to_s
    end

    protected
      def source?
        valid? && compiler.source?
      end

      def compiler
        @compiler ||= Compiler.for_extension(ext)
      end
  end
end