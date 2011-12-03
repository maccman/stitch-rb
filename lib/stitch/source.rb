require "pathname"

module Stitch
  class Source
    class << self
      def from_path(root, path = nil, result = [])
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

      def from_file(root, path = nil, result = [])
        unless path
          path = root
          root = root.dirname
        end

        source = self.new(root, path)
        source.requires.each do |child|
          from_file(root, child, result)
        end

        raise "Recursive" if result.include?(source)
        result << source
      end

      def resolve(path, relative_to)
        path        = Pathname.new(path)
        relative_to = Pathname.new(relative_to)

        unless path.absolute?
          path = path.expand_path(relative_to)
        end

        return path if path.exist?

        Compiler.source_extensions.each do |ext|
          candidate = Pathname.new(path.to_s + "." + ext)
          return candidate if candidate.exist?
        end

        raise "#{path} not found"
      end
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

    def requires
      return [] unless source?
      requires = path.read.scan(/require\(("|')(.+)\1\)/)
      requires.map {|(_, pn)| self.class.resolve(pn, root) }
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