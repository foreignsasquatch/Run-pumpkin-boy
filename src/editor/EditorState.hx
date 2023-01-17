package editor;

import engine.Level;
import engine.State;
import engine.assets.Assets;

class EditorState extends State {
  public var level:Level;
  public var currentLayer:Layers = FG;
  public var currentTile:Int = 2;

  public var canEdit:Bool = false;
  public var currentMouseX:Int;
  public var currentMouseY:Int;

  var font:Rl.Font;

  override function init() {
    Assets.load(["assets/tileset.ase"]);

    level = new Level(800, 600, 16, Assets.textures.get("tileset"));
    level.load("assets/world.map");
    trace(level.tilesetMap.get(30));

    font = Rl.loadFont("assets/alphbeta.ttf");
  }

  override function step() {
    currentMouseX = Std.int(Rl.getMouseX() / 16);
    currentMouseY = Std.int(Rl.getMouseY() / 16);

    // stupid tile selection
    if(Rl.isKeyPressed(Rl.Keys.RIGHT)) currentTile++;
    if(Rl.isKeyPressed(Rl.Keys.LEFT)) if(currentTile != 1) currentTile--;

    if(canEdit) {
      if(Rl.isMouseButtonDown(Rl.MouseButton.LEFT)) level.setTile(currentMouseX, currentMouseY, currentTile, currentLayer);
      if(Rl.isMouseButtonDown(Rl.MouseButton.RIGHT)) level.removeTile(currentMouseX, currentMouseY, currentLayer);
    }

    if(Rl.isKeyDown(Rl.Keys.ONE)) currentLayer = FG;
    if(Rl.isKeyDown(Rl.Keys.TWO)) currentLayer = BG;

    if(Rl.isKeyPressed(Rl.Keys.S)) level.save("assets/world.map");
    if(Rl.isKeyPressed(Rl.Keys.W)) canEdit = !canEdit;
  }

  override function draw() {
    level.draw();

    var fps = Rl.getFPS();
    Rl.drawTextEx(font, 'FPS: $fps', Rl.Vector2.create(0, 0), font.baseSize, 2, Rl.Colors.YELLOW);
    Rl.drawTextEx(font, 'Layer: $currentLayer', Rl.Vector2.create(0, font.baseSize + 5), font.baseSize, 2, Rl.Colors.YELLOW);
    Rl.drawTextEx(font, 'Can edit: $canEdit', Rl.Vector2.create(0, font.baseSize * 2 + 10), font.baseSize, 2, Rl.Colors.YELLOW);
    Rl.drawTextEx(font, 'Current tile: $currentTile', Rl.Vector2.create(0, font.baseSize * 3 + 10), font.baseSize, 2, Rl.Colors.YELLOW);

    Rl.drawTextureRec(level.tileset, Rl.Rectangle.create(level.tilesetMap.get(currentTile)[1], level.tilesetMap.get(currentTile)[0], 16, 16), Rl.Vector2.create(0, font.baseSize * 4 + 10), Rl.Colors.WHITE);
  }
}