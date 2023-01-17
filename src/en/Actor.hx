package en;

import engine.Entity;
import engine.Level;

class Actor extends Entity {
  public var speed = 0.03;

  public function new(l:Level) {
    super(0, 0, l);
  }
  
  override function step() {
    if(Rl.isKeyDown(Rl.Keys.W)) dy -= speed;
    if(Rl.isKeyDown(Rl.Keys.S)) dy = speed;
    if(Rl.isKeyDown(Rl.Keys.A)) dx -= speed;
    if(Rl.isKeyDown(Rl.Keys.D)) dx = speed;
  }

  override function draw() {
    debugDraw();
  }
}