module Stitch
  class SerenadeCompiler < Compiler
    extensions :serenade

    def compile(path)
      content = File.read(path)
      serenade_path = if ENV['STITCH_SERENADE_ROOT']
        root = ENV['STITCH_SERENADE_ROOT']
        root = root + "/" unless root[-1..-1] == "/"
        path.to_s.gsub(/#{root}/, "")
      else
        path
      end
      # always remove .serenade ending
      serenade_path.gsub!(/\.serenade$/, "")

      %{var viewtemplate = '#{content}';
        var view = Serenade.view('#{serenade_path}', viewTemplate);
        module.exports = view;
      }
    end
  end
end
