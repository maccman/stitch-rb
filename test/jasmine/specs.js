describe("Stitch", function(){
  it("should have require function", function(){
    expect(typeof require).toBe("function");
  });

  it("should be able to require modules", function(){
    expect(typeof require("models/user")).toBe("function");
  });

  it("should recursively find modules", function(){
    expect(typeof require("models/orm")).toBe("string");
  });
});