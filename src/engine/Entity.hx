package engine;

class Entity {
  public var cx:Int;
  public var cy:Int;

  public var xr:Float;
  public var yr:Float;

  public var dx:Float;
  public var dy:Float;

  public var fx:Float = 0.98;
  public var fy:Float = 0.98;

  public var xx:Float;
  public var yy:Float;

  public var radius:Float;

  public var isColliding = false;
  public var collisionLayer:Level;

  public var texture:Rl.Texture;

  public static var ALL:Array<Entity> = [];

  public function new(x:Float, y:Float, l:Level) {
    setCoords(x, y);
    collisionLayer = l;
    ALL.push(this);
  }

  public function step() {}
  public function draw() {}

  public function dispose() {
    ALL.remove(this);
    Rl.unloadTexture(texture);
  }

  public function setCoords(x:Float, y:Float) {
    xx = x;
    yy = y;
    cx = Std.int(x / 16);
    cy = Std.int(y / 16);
    xr = (x - cx * 16) / 16;
    yr = (y - cy * 16) / 16;
  }

  public function updatePhysics() {
    xr += dx;
    dx *= fx;

    if(collisionLayer.hasCollidingTiles(cx + 1,cy) && xr >= 0) {
      xr = 0;
      dx = 0;
      isColliding = true;
    } else {
      isColliding = false;
    }

    if(collisionLayer.hasCollidingTiles(cx - 1,cy) && xr <= 0) {
      xr = 0;
      dx = 0;
      isColliding = true;
    } else {
      isColliding = false;
    }

    while(xr > 1) {
      xr--; cx++;
    }
    while(xr < 0) {
      xr++; cx--;
    }

    yr += dy;
    dy *= fy;

    // Top
    if(collisionLayer.hasCollidingTiles(cx,cy - 1) && yr <= 0) {
      yr = 0;
      dy = 0;
      isColliding = true;
    } else {
      isColliding = false;
    }

    // Bottom
    if(collisionLayer.hasCollidingTiles(cx,cy + 1) && yr >= 0) {
      yr = 0;
      dy = 0;
      isColliding = true;
    } else {
      isColliding = false;
    }

    while(yr > 1) {
      yr--;cy++;
    }
    while(yr < 0) {
      yr++;cy--;
    }

    xx = (cx + xr) * 16;
    yy = (cy + yr) * 16;
  }

  // Resolve collision among entities
  public function resolveCollision() {
    for(e in ALL) {
      if(e != this && Math.abs(cx - e.cx) <= 2  && Math.abs(cy - e.cy) <= 2) {
        var dist = Math.sqrt((e.xx - xx) * (e.xx - xx) + (e.yy - yy) * (e.yy - yy));
        if(dist <= radius + e.radius) {
          var ang = Math.atan2(e.yy - yy, e.xx - xx);
          var force = 0.2;
          var repelPower = (radius + e.radius - dist) / (radius + e.radius);
          dx -= Math.cos(ang) * repelPower * force;
          dy -= Math.sin(ang) * repelPower * force;
          e.dx += Math.cos(ang) * repelPower * force;
          e.dy += Math.sin(ang) * repelPower * force;
        }
      }
    }
  }

  public inline function overlapsEntity(e:Entity):Bool {
    var maxDist = radius + e.radius;
    var distSqr = (e.xx - xx) * (e.xx - xx) + (e.yy - yy) * (e.yy - yy);
    return distSqr <= maxDist * maxDist;
  }

  public function debugDraw() {
  }
}
