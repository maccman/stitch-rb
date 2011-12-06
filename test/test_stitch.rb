require File.dirname(__FILE__) + '/test_helper.rb'

class TestStitch < Test::Unit::TestCase
  def setup
  end

  def test_stitch
    compare = File.read(File.dirname(__FILE__) + '/results/index.js')
    result  = Stitch::Package.new(
      :files => [File.dirname(__FILE__) + '/fixtures/app/index.js'],
      :root  => File.dirname(__FILE__) + '/fixtures/app'
    ).compile
    assert_equal compare, result
  end

  def test_dependencies
    compare = File.read(File.dirname(__FILE__) + '/results/app.js')
    result  = Stitch::Package.new(
      :paths => [File.dirname(__FILE__) + '/fixtures/app']
    ).compile
    assert_equal compare, result
  end
end