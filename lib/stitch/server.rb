module Stitch
  class Server
    def initialize(options = {})
      @package = Package.new(options)
    end
    
    def call(env)
      [200, {"Content-Type" => "text/javascript"}, [@package.compile]]
    end
  end
end