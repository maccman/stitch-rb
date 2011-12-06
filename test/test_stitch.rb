require File.dirname(__FILE__) + '/test_helper.rb'

class TestJasmine < Test::Unit::TestCase
  def setup
  end

  def test_stitch
    File.open(File.dirname(__FILE__) + '/jasmine/index.js', 'w+') do |f|
      f.write Stitch::Package.new(
        :files => [File.dirname(__FILE__) + '/fixtures/app/index.js'],
        :root  => File.dirname(__FILE__) + '/fixtures/app'
      ).compile
    end
    system 'open', File.dirname(__FILE__) + '/jasmine/index.html'
  end
end