import en.Actor;
import engine.Level;
import engine.Utils;
import engine.assets.Assets;

class PlayState extends engine.State {
  public var level:Level;
  public var font:Rl.Font;
  public var actor:Actor;
  public var camera:Rl.Camera2D;

  override function init() {
    Assets.load(["assets/tileset.ase"]);
    Assets.load(["assets/alphbeta.ttf"]);

    level = new Level(800, 600, 16, Assets.textures.get("tileset"));
    level.load("assets/world.map");

    font = Assets.fonts.get("alphbeta");

    actor = new Actor(level);
    camera = Rl.Camera2D.create(Rl.Vector2.create(Rl.getScreenWidth() / 2, Rl.getScreenHeight() / 2), Rl.Vector2.create(actor.xx, actor.yy), 0, 3.5);
  }

  override function step() {
    actor.step();
    // camera = Utils.followCameraInBounds(actor, 272, 192, 736, 496);
    camera = Utils.followCameraInBounds(actor, Rl.Rectangle.create(304, 208, 32 * 16,  26 * 16));
  }

  override function draw() {
    Rl.beginMode2D(camera);
    {
      level.draw();
      actor.draw();
      Rl.drawRectangleLines(304, 208, 32 * 16, 26 * 16, Rl.Colors.RED);
    }
    Rl.endMode2D();

    Rl.drawTextEx(font, 'X: ${Std.int(actor.xx)} Y: ${Std.int(actor.yy)}', Rl.Vector2.create(0, 0), font.baseSize, 2, Rl.Colors.YELLOW);
  }
}