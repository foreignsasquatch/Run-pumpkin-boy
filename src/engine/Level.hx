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

typedef Tile = {
  x:Int,
  y:Int,
  id:Int
}

class Level {
  public var width:Int;
  public var height:Int;
  public var tileSize:Int;
  public var fg:Array<Int> = [];
  public var bg:Array<Int> = [];
  public var en:Array<Int> = [];

  public var tilesb:Array<Tile> = [];
  public var tilesf:Array<Tile> = [];

  public var tileset:Rl.Texture;
  public var tilesetRec:Map<Int, Rl.Rectangle> = [];

  public var saveData:LSaveData;

  public function new(width:Int, height:Int, tileSize:Int, tileset:Rl.Texture) {
    this.width  = width;
    this.height = height;
    this.tileSize = tileSize;
    this.tileset = tileset;

    // Generate tileset
    var i = 1;
    for(c in 0...256) {
      for(r in 0...256) {
        var rec = Rl.Rectangle.create(r * 16, c * 16, 16, 16);
        tilesetRec.set(i, rec);
        i++;
      }
    }
  }

  public function save(f:String) {
    var bg:Array<Int> = [];
    for(tb in tilesb) {
      var xb = Std.int(tb.x / 16);
      var yb = Std.int(tb.y / 16);
      bg[yb * width + xb] = tb.id;
    }

    var fg:Array<Int> = [];
    for(t in tilesf) {
      var x = Std.int(t.x / 16);
      var y = Std.int(t.y / 16);
      fg[y * width + x] = t.id;
    }

    trace("Saved level");

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

    // Generate tiles from array
    for(c in 0...width) {
      for(r in 0...height) {
        if(bg[r * width + c] != 0) {
          tilesb.push({x: c * 16, y: r * 16, id: bg[r * width + c]});
        }
      }
    }

    for(c in 0...width) {
      for(r in 0...height) {
        if(fg[r * width + c] != 0) {
          tilesf.push({x: c * 16, y: r * 16, id: fg[r * width + c]});
        }
      }
    }
  }

  public function setTile(c:Int, r:Int, tile:Int, l:Layers) {
    if(l == FG) {
      tilesf.push({x: c * 16, y: r * 16, id: tile});
    }
    else if(l == BG) {
      tilesb.push({x: c * 16, y: r * 16, id: tile});
    }
  }

  public function removeTile(c:Int, r:Int, l:Layers) {
    if(l == FG) {
      for(t in tilesf) {
        if(t.x == c * 16 && t.y == r * 16) tilesf.remove(t);
      }
    } else if(l == BG) {
      for(t in tilesb) {
        if(t.x == c * 16 && t.y == r * 16) tilesb.remove(t);
      }
    }
  }

  public function hasCollidingTiles(c:Int, r:Int) {
    var t = false;
    for(i in tilesf) {
      var x = Std.int(i.x / 16);
      var y = Std.int(i.y / 16);
      if(c == x && r == y) t = true;
    }
    return t;
  }

  public function draw() {
    for(t in tilesb) {
      Rl.drawTextureRec(tileset, tilesetRec.get(t.id), Rl.Vector2.create(t.x, t.y), Rl.Colors.WHITE);
    }
    for(t in tilesf) {
      Rl.drawTextureRec(tileset, tilesetRec.get(t.id), Rl.Vector2.create(t.x, t.y), Rl.Colors.WHITE);
    }
  }
}