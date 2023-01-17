package engine;

enum Layers {
  FG;
  BG;
}

typedef LSaveData =  {
  width:Int,
  height:Int,
  tileSize:Int,
  fg:Array<Int>,
  bg:Array<Int>,
  en:Array<Int>
}

class Level {
  public var width:Int;
  public var height:Int;
  public var tileSize:Int;
  public var fg:Array<Int> = [];
  public var bg:Array<Int> = [];
  public var en:Array<Int> = [];

  public var tileset:Rl.Texture;
  public var tilesetMap:Map<Int, Array<Int>> = [];

  public var saveData:LSaveData;

  public function new(width:Int, height:Int, tileSize:Int, tileset:Rl.Texture) {
    this.width  = width;
    this.height = height;
    this.tileSize = tileSize;
    this.tileset = tileset;

    // Generate tileset map
    var i = 1;
    for(c in 0...256) {
      for(r in 0...256) {
        tilesetMap.set(i, [c * 16, r * 16]);
        i++;
      }
    }
  }

  public function save(f:String) {
    saveData = {width: width, height: height, tileSize: tileSize,  fg: fg, bg: bg, en: en};
    sys.io.File.saveContent(f, haxe.Json.stringify(saveData, " "));
  }

  public function load(f:String) {
    saveData = haxe.Json.parse(sys.io.File.getContent(f));
    width = saveData.width;
    height = saveData.height;
    tileSize = saveData.tileSize;
    fg = saveData.fg;
    bg = saveData.bg;
  }

  public function setTile(c:Int, r:Int, tile:Int, l:Layers) {
    if(l == FG)
      fg[r * width + c] = tile;
    else if(l == BG)
      bg[r * width + c] = tile;
  }

  public function removeTile(c:Int, r:Int, l:Layers) {
    if(l == FG)
      fg[r * width + c] = 0;
    else if(l == BG)
      bg[r * width + c] = 0;
  }

  public function getTileFg(c:Int, r:Int):Int {
    return fg[r * width + c];
  }

  public function getTileBg(c:Int, r:Int):Int {
    return bg[r * width + c];
  }

  public function hasCollidingTiles(c:Int, r:Int) {
    return fg[r * width + c] != 0;
  }

  public function draw() {
    for(c in 0...width) {
      for(r in 0...height) {
        var tileB = getTileBg(c, r);
        var tile = getTileFg(c, r);
        var x = c * 16;
        var y = r * 16;

        if(tileB != 0) {
          Rl.drawTextureRec(tileset, Rl.Rectangle.create(tilesetMap.get(tileB)[1], tilesetMap.get(tileB)[0], tileSize, tileSize), Rl.Vector2.create(x, y), Rl.Colors.WHITE);
        }

        if(tile != 0) {
          Rl.drawTextureRec(tileset, Rl.Rectangle.create(tilesetMap.get(tile)[1], tilesetMap.get(tile)[0], tileSize, tileSize), Rl.Vector2.create(x, y), Rl.Colors.WHITE);
        }
      }
    }
  }
}