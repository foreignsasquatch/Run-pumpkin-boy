package engine;

// Common utils just small functions
class Utils {
  public static function followCameraInBounds(e:Entity, bounds:Rl.Rectangle):Rl.Camera2D {
    var width = 1280;
    var height = 720;

    var c = Rl.Camera2D.create(Rl.Vector2.create(Rl.getScreenWidth() / 2, Rl.getScreenHeight() / 2), Rl.Vector2.create(e.xx, e.yy), 0, 2.5);
    c.target = Rl.Vector2.create(e.xx, e.yy);
    c.offset = Rl.Vector2.create(Rl.getScreenWidth() / 2, Rl.getScreenHeight() / 2);

    var minX = 1000.; 
    var minY = 1000.; 
    var maxX = -1000.; 
    var maxY = -1000.;

    minX = (bounds.x);
    maxX = (bounds.x + bounds.width);
    minY = (bounds.y);
    maxY = (bounds.y + bounds.height);

    var max = Rl.getWorldToScreen2D(Rl.Vector2.create(maxX, maxY), c);
    var min = Rl.getWorldToScreen2D(Rl.Vector2.create(minX, minY), c);

    if (max.x < width) c.offset.x = width - (max.x - width/2);
    if (max.y < height) c.offset.y = height - (max.y - height/2);
    if (min.x > 0) c.offset.x = width/2 - min.x;
    if (min.y > 0) c.offset.y = height/2 - min.y;

    return c;
  }
}