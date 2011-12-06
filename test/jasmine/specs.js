describe("Stitch", function(){
  it("should have require function", function(){
    expect(typeof require).toBe("function");
  });

  it("should be able to require modules", function(){
    expect(typeof require("models/user")).toBe("function");
  });

  it("should recursively find modules", function(){
    var obj = require("models/orm");

    expect(obj).toEqual({orm: true});
    expect(obj).toBe(require("models/orm"));
  });

  it("should transitively require dependencies", function(){
    expect(require("models/user").ORM).toEqual({orm: true});
  });

  it("should not load the same module twice", function(){
    require("models/user");
    require("models/person");

    expect(window.ormCount).toBe(1);
  });
});