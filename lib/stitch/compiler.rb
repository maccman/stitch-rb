module Stitch
  class Compiler
    class << self
      def compilers
        @compilers ||= []
      end

      def inherited(child)
        Compiler.compilers.unshift(child)
      end

      def all
        Compiler.compilers.select {|c| c.enabled? }
      end

      def all_extensions
        Compiler.all.map {|c| c.extensions }.flatten
      end

      def for_extension(extension)
        extension.gsub!(/^\./, "")
        all.find do |item|
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

      def source(value)
        @source = value
      end

      def source?
        @source || false
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
require "stitch/compilers/tmpl"
require "stitch/compilers/mustache"
require "stitch/compiler/eco"
