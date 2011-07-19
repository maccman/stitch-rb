require "pathname"

module Stitch
  class Dependency
    class << self
      def from_path(path, result = [])
        path = Pathname.new(path)
        
        if path.directory?
          path.children.each do |child| 
            from_path(child, result)
          end
        else
          dependency = self.new(path)
          result << dependency if dependency.valid?
        end
        result
      end
    end
    
    attr_reader :path
    
    def initialize(path)
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