require File.dirname(__FILE__) + '/test_helper.rb'

class TestJasmine < Test::Unit::TestCase
  def setup
  end

  def test_stitch
    root = File.dirname(__FILE__)
    File.open(root + '/jasmine/index.js', 'w+') do |f|
      f.write Stitch::Package.new(
        :files => [root + '/fixtures/app/index.js'],
        :root  =>  root + '/fixtures/app'
      ).compile
    end
    system 'open', root + '/jasmine/index.html'
  end
end