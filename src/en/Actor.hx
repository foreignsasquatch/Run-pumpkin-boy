package en;

import engine.Entity;
import engine.Level;
import engine.assets.Assets;

class Actor extends Entity {
  public var speed = 0.11;
  public var invertWhileWalk = 1;
  public var rotation = 0;

  public var animX:Int;
  public var currentFrame = 0;
  public var framesCounter = 0;
  public var framesSpeed = 5;

  public function new(l:Level) {
    super(568, 404, l);
    texture = Assets.textures.get("spritesheet");
    radius = 6.5;

    fx = 0.8;
    fy = 0.8;
  }

  var playWalk = false;
  override function step() {
    if(Rl.isKeyDown(Rl.Keys.W)) { 
      dy = -speed;
    }
    if(Rl.isKeyDown(Rl.Keys.S)) {
      dy = speed;
    }
    if(Rl.isKeyDown(Rl.Keys.A)) {
      dx = -speed;
      invertWhileWalk = 1;
    }
    if(Rl.isKeyDown(Rl.Keys.D)) {
      dx = speed;
      invertWhileWalk = -1;
    }

    framesCounter++;

    if(framesCounter >= (60/framesSpeed)) {
      framesCounter = 0;
      currentFrame++;
      if(currentFrame > 3) currentFrame = 0;
      animX = currentFrame * 16;
    }

    resolveCollision();
    updatePhysics();
  }

  override function draw() {
    Rl.drawTexturePro(texture, Rl.Rectangle.create(animX, 0, 9, 16), Rl.Rectangle.create(xx, yy, 8, 16), Rl.Vector2.create(4, 7.5), rotation, Rl.Colors.WHITE);
    // debugDraw();
  }
}