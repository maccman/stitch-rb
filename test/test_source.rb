require File.dirname(__FILE__) + "/test_helper.rb"

class TestSource < Test::Unit::TestCase
  FIXTURES = Pathname.new(File.join(File.dirname(__FILE__), "fixtures"))

  def setup
  end

  def test_from_file
    sources = Stitch::Source.from_file(FIXTURES.join(*%w{app index.js}))
    sources = sources.map {|s| s.path.relative_path_from(FIXTURES).to_s }
    assert_equal [
      "app/models/orm.js",
      "app/models/user.js",
      "app/models/orm.js",
      "app/models/person.js",
      "app/index.js"
    ], sources
  end

  def test_from_path
    sources = Stitch::Source.from_path(FIXTURES.join("app"))
    sources = sources.map {|s| s.path.relative_path_from(FIXTURES).to_s }
    assert_equal [
      "app/controllers/users.coffee",
      "app/index.js",
      "app/models/orm.js",
      "app/models/person.js",
      "app/models/user.js"
    ], sources
  end

  def test_resolve
    path = Stitch::Source.resolve("index.js", File.join(FIXTURES, "app"))
    assert_equal path.relative_path_from(FIXTURES).to_s, "app/index.js"

    path = Stitch::Source.resolve("index", File.join(FIXTURES, "app"))
    assert_equal path.relative_path_from(FIXTURES).to_s, "app/index.js"
  end

  def test_require
    source  = Stitch::Source.new(FIXTURES.join("app"), FIXTURES.join(*%w{app index.js}))
    sources = source.requires.map {|s| s.relative_path_from(FIXTURES).to_s }
    assert_equal ["app/models/user.js", "app/models/person.js"], sources
  end
end