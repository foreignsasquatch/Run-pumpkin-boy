package en;

import engine.Entity;
import engine.Level;
import engine.assets.Assets;

class Eye extends Entity {
  public var resetOffset = 0;
  public var offsetX = Rl.getRandomValue(-150, 150);
  public var offsetY = Rl.getRandomValue(-150, 150);
  public var invertWhileWalk = 1;
  public var bullets:Array<Bullet> = [];

  public function new(x:Float, y:Float, l:Level) {
    super(x, y, l);

    texture = Assets.textures.get("spritesheet");
    radius = 3;
  }

  override function step() {
    if(bullets.length < 20) {
      bullets.push(new Bullet(xx, yy, PlayState.actor.xx, PlayState.actor.yy));
    }

    for(b in bullets) {
      if(!b.dead) {
        b.step();
      }

      if(b.dead) {
        Entity.ALL.remove(b);
        bullets.remove(b);
      }
    }

    moveTowardsActor();
    updatePhysics();
  }

  override function draw() {
    for(b in bullets) {
      if(!b.dead) {
        b.draw();
      }
    }

    Rl.drawTexturePro(texture, Rl.Rectangle.create(0, 16, 11 * invertWhileWalk, 11), Rl.Rectangle.create(xx, yy, 11, 11), Rl.Vector2.create(5.5, 5.5), 0, Rl.Colors.WHITE);
    // debugDraw();
  }

  var speed = 0.07;
  public function moveTowardsActor() {
    if(resetOffset == 0) {
      offsetX = Rl.getRandomValue(-100, 200);
      offsetY = Rl.getRandomValue(-100, 200);
      resetOffset = Rl.getRandomValue(50, 100);
    } else {
      resetOffset--;
    }

    if(PlayState.actor.xx + offsetX > xx) {
      dx = speed;
      invertWhileWalk = 1;
    } else {
      dx = -speed;
      invertWhileWalk = -1;
    }

    if(PlayState.actor.yy + offsetY > yy) {
      dy = speed;
      invertWhileWalk = 1;
    } else {
      invertWhileWalk = -1;
      dy = -speed;
    }
  }
}