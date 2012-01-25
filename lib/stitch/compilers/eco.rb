module Stitch
  class EcoCompiler < Compiler
    extensions :eco

    enabled begin
      require "eco"
      true
    rescue LoadError
      false
    end

    source true

    def compile(path)
      source = File.read(path)
      %{module.exports = #{Eco.compile(source)}}
    end
  end
end
