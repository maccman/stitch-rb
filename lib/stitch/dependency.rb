require "pathname"

module Stitch
  class Dependency
    class << self
      def from_path(root, path = nil, result = [])
        path ||= root
        path = Pathname.new(path)
        
        if path.directory?
          path.children.each do |child| 
            from_path(root, child, result)
          end
        else
          dependency = self.new(root, path)
          result << dependency if dependency.valid?
        end
        result
      end
    end
    
    attr_reader :root, :path
    
    def initialize(root, path)
      @root = Pathname.new(root)
      @path = Pathname.new(path)
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