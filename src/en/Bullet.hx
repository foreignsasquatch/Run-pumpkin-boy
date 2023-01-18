package en;

import engine.Entity;
import engine.assets.Assets;

class Bullet extends Entity {
  var mx = 0.0;
  var my = 0.0;

  public function new(x:Float, y:Float, m, b) {
    super(x, y, PlayState.level);
    mx = m;
    my = b;

    radius = 8;
    texture = Assets.textures.get("spritesheet");
  }

  var timer = 2.;
  public var dead = false;
  override function step() {
    timer -= 0.1;

    if(timer > 0) {
      if(mx > xx) {
        dx = 0.1;
      } else {
        dx = -0.1;
      }

      if(my > yy) {
        dy = 0.1;
      }   else {
        dy = -0.1;
      }
    }

    if(timer < 0) dead = true;
    updatePhysics();
  }

  override function draw() {
    Rl.drawTexturePro(texture, Rl.Rectangle.create(16, 16, 8, 8), Rl.Rectangle.create(xx, yy, 8, 8), Rl.Vector2.create(4, 4), 0, Rl.Colors.WHITE);
    // debugDraw();
  }
}