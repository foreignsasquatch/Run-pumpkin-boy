package en;

import engine.Entity;
import engine.Level;

class Actor extends Entity {
  public var speed = 0.15;

  public function new(l:Level) {
    super(500, 340, l);

    fx = 0.8;
    fy = 0.8;
  }
  
  override function step() {
    if(Rl.isKeyDown(Rl.Keys.W)) dy = -speed;
    if(Rl.isKeyDown(Rl.Keys.S)) dy = speed;
    if(Rl.isKeyDown(Rl.Keys.A)) dx = -speed;
    if(Rl.isKeyDown(Rl.Keys.D)) dx = speed;

    updatePhysics();
  }

  override function draw() {
    Rl.drawRectangleRec(Rl.Rectangle.create(xx, yy, 16, 16), Rl.Colors.RED);
    debugDraw();
  }
}