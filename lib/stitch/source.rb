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
    end
    
    attr_reader :root, :path
    
    def initialize(root, path)
      @root = Pathname.new(root)
      @path = Pathname.new(path)
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
    
    protected  
      def compiler
        Compiler.for_extension(ext)
      end
  end
end