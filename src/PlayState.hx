import en.Actor;
import en.Eye;
import engine.Entity;
import engine.Level;
import engine.Utils;
import engine.assets.Assets;

class PlayState extends engine.State {
  public static var level:Level;
  public var font:Rl.Font;
  public static var actor:Actor;
  public var camera:Rl.Camera2D;
  public var dead = false;
  public var timer = 0.;

  public static var eyes:Array<Eye> = [];

  override function init() {
    Assets.load(["assets/tileset.ase"]);
    Assets.load(["assets/spritesheet.ase"]);
    Assets.load(["assets/alphbeta.ttf"]);

    level = new Level(800, 600, 16, Assets.textures.get("tileset"));
    level.load("assets/world.map");

    font = Assets.fonts.get("alphbeta");

    actor = new Actor(level);
    for(i in 0...10) {
      if(i <= 10) {
        eyes.push(new Eye(Rl.getRandomValue(320, 280 + 32 * 16), Rl.getRandomValue(230, 190 + 26 * 16), level));
      }
    }
    camera = Rl.Camera2D.create(Rl.Vector2.create(Rl.getScreenWidth() / 2, Rl.getScreenHeight() / 2), Rl.Vector2.create(actor.xx, actor.yy), 0, 7);
  }

  var isjustdead = false;
  var inc = 3.0;
  override function step() {
    if(!dead) {
      timer += 0.016;
      actor.step();
      for(e in eyes) e.step();
      camera = Utils.followCameraInBounds(actor, Rl.Rectangle.create(304, 208, 32 * 16,  26 * 16), camera.rotation, camera.zoom);
    }

    if(actor.isCollidingWithEn) dead = true;
    if(dead && Rl.isKeyPressed(Rl.Keys.ENTER)) {
      reset();
      dead = false;
      isjustdead = true;
    }

    if(isjustdead) {
      inc -= 0.1;
      if(inc < 0) {
        for(i in 0...10) {
          if(i <= 10) {
            eyes.push(new Eye(Rl.getRandomValue(320, 280 + 32 * 16), Rl.getRandomValue(230, 190 + 26 * 16), level));
          }
        }

        isjustdead = false;
        inc = 3;
      }
    }
  }

  public function reset() {
    actor.dispose();
    actor = null;
    for(e in eyes) {
      e.dispose();
    }
    eyes = [];
    Entity.ALL = [];

    actor = new Actor(level);
    timer = 0;
  }

  override function draw() {
    Rl.beginMode2D(camera);
    {
      level.draw();
      if(!dead) {
        actor.draw();
        for(e in eyes) e.draw();
      }
    }
    Rl.endMode2D();
  
    if(!dead) {
      Rl.drawTextEx(font, Std.int(timer) + 's', Rl.Vector2.create(0, 0), font.baseSize, 2, Rl.Colors.YELLOW);
    }

    if(dead) {
      Rl.drawRectangle(0, 0, 1280, 720, Rl.Color.create(0, 0, 0, 150));
      Rl.drawTextEx(font, 'You died', Rl.Vector2.create(0, 0), font.baseSize * 2, 2, Rl.Colors.YELLOW);
      Rl.drawTextEx(font, 'Press [ENTER] to play again', Rl.Vector2.create(0, font.baseSize * 2 + 40), font.baseSize * 2, 2, Rl.Colors.YELLOW);
      Rl.drawTextEx(font, 'Time survived: ${Std.int(timer)}', Rl.Vector2.create(0, font.baseSize + 20), font.baseSize * 2, 2, Rl.Colors.YELLOW);
    }
  }
}