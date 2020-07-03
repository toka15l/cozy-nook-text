package;
import openfl.display.Bitmap;
import openfl.display.MovieClip;
import openfl.geom.Point;
//import Item.ItemEvent;

class World extends MovieClip
{
	public var DIRECTION_LEFT:String = "left";
	public var DIRECTION_RIGHT:String = "right";
	private static var ZOOM_FACTOR:Int = 1;
	private static var INITIAL_SCALE:Int = 3;
	private var bitmaps:Bitmaps = null;
	private var tiles:Array<Tile> = [];
	
	public function new() {
		super();
		
		scaleX = scaleY = INITIAL_SCALE;
		
		bitmaps = new Bitmaps();
		
		addItemToTile(new Dwarf(), 1, 2);
		addItemToTile(new Plus(), 5, 5);
	}
	
	private function addItemToTile(item:Item, x:Int, y:Int):Void {
		var tile:Tile = cast getChildByName("tile_" + x + "_" + y);
		if (tile == null) {
			tile = new Tile();
			tile.tileX = x;
			tile.tileY = y;
			tile.x = x * Bitmaps.SPRITE_WIDTH;
			tile.y = y * Bitmaps.SPRITE_HEIGHT;
			tile.name = "tile_" + x + "_" + y;
			addChild(tile);
		}
		tile.addItem(item);
		item.addBitmap(bitmaps.getBitmapForCoordinates(item.spriteX, item.spriteY));
	}
	
	public function zoomIn():Void {
		changeZoom(ZOOM_FACTOR);
	}
	
	public function zoomOut():Void {
		changeZoom(ZOOM_FACTOR * -1);
	}
	
	private function changeZoom(change:Int):Void {
		if (scaleX + change <= 0) {
			return;
		}
		scaleX += change;
		scaleY += change;
	}
	
	public function move(direction:String):Void {
		/*for (x in 0...itemMatrix.length) {
			for (y in 0...itemMatrix[x].length) {
				var item:Item = itemMatrix[x][y];
				if (item != null && item.bitmap == bitmaps.PLUS) {
					switch (direction) {
						case "left":
							//itemMatrix[x][y - 1] = item;
							addItem(item.bitmap, x - 1, y);
						case "right":
							addItem(item.bitmap, x + 1, y);
						default:
					}
					//item.needsRedraw = true;
					itemMatrix[x][y] = null;
					trace(itemMatrix);
					break;
				}
			}
		}*/
	}
}