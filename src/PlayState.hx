import engine.Level;
import engine.assets.Assets;

class PlayState extends engine.State {
  public var level:Level;

  override function init() {
    Assets.load(["assets/tileset.ase"]);
    Assets.load(["assets/alphbeta.ttf"]);

    level = new Level(800, 600, 16, Assets.textures.get("tileset"));
    level.load("assets/world.map");
  }

  override function step() {
  }

  override function draw() {
    level.draw();
  }
}