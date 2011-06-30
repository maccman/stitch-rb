module Stitch
  class Compiler
    class << self
      def compilers
        @compilers ||= []
      end
      
      def inherited(child)
        Compiler.compilers.unshift(child)
      end
      
      def for_extension(extension)
        extension.gsub!(/^\./, "")
        Compiler.compilers.select(&:enabled?).find do |item| 
          item.extensions.include?(extension) 
        end
      end
      
      # Child methods
      
      def extensions(*exts)
        @extensions ||= []
        @extensions |= exts.map(&:to_s)
      end
      
      def enabled(value)
        @enabled = value
      end
      
      def enabled?
        @enabled != false
      end
      
      def compile(*args)
        self.new.compile(*args)
      end
    end
    
    def compile(filename)
      raise "Re-implement"
    end
  end
end

# Require default compilers
require "stitch/compilers/javascript"
require "stitch/compilers/coffeescript"