module Stitch
  class SerenadeCompiler < Compiler
    extensions :serenade

    def compile(path)
      content = File.read(path)
      # make it possible to register the view as a relative path
      # more intuitive than as an absolute path (all the way to /)
      # set the environment variable STITCH_SERENADE_ROOT to the
      # point in the hierarchy where you want relative paths
      # from
      serenade_path = if ENV['STITCH_SERENADE_ROOT']
        root = ENV['STITCH_SERENADE_ROOT']
        root = root + "/" unless root[-1..-1] == "/"
        path.to_s.gsub(/#{root}/, "")
      else
        path
      end
      # always remove .serenade ending
      serenade_path.gsub!(/\.serenade$/, "")

      %{var viewTemplate = '#{content}';
        var view = Serenade.view('#{serenade_path}', viewTemplate);
        module.exports = view;
      }
    end
  end
end
