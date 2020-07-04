package;
import openfl.display.Bitmap;
import openfl.display.MovieClip;
import openfl.geom.Point;
import Item.ItemEvent;
import Tile.TileEvent;
import openfl.Lib.*;

class World extends MovieClip
{
	private static inline var ZOOM_FACTOR:Int = 1;
	private static inline var INITIAL_SCALE:Int = 3;
	private static inline var ITEM_CYCLE_INTERVAL:Int = 800;
	private var bitmaps:Bitmaps = null;
	private var tiles:Array<Tile> = [];
	private var plus:Plus = null;
	private var tilesContainingMultipleItems:Array<Tile> = [];
	
	public function new() {
		super();
		
		scaleX = scaleY = INITIAL_SCALE;
		
		bitmaps = new Bitmaps();
		
		addItemToTile(new Dwarf(), 1, 2);
		
		plus = new Plus();
		addItemToTile(plus, 5, 5);
		
		addEventListener(ItemEvent.MOVE, itemMove);
		addEventListener(TileEvent.REGISTER_CONTAINS_MULTIPLE_ITEMS, registerContainsMultipleItems);
		addEventListener(TileEvent.DEREGISTER_CONTAINS_MULTIPLE_ITEMS, deregisterContainsMultipleItems);
		
		setInterval(cycleItems, ITEM_CYCLE_INTERVAL);
	}
	
	private function registerContainsMultipleItems(e:TileEvent):Void {
		tilesContainingMultipleItems.push(e.target);
	}
	
	private function deregisterContainsMultipleItems(e:TileEvent):Void {
		tilesContainingMultipleItems.remove(e.target);
	}
	
	private function cycleItems():Void {
		for (tile in tilesContainingMultipleItems) {
			tile.cycleItems();
		}
	}
	
	private function itemMove(e:ItemEvent):Void {
		var item:Item = cast e.target;
		var tile:Tile = cast item.parent;
		addItemToTile(item, tile.tileX + e.distanceX, tile.tileY + e.distanceY);
		removeItemFromTile(item, tile);
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
	
	private function removeItemFromTile(item:Item, tile:Tile):Void {
		tile.removeItem(item);
		if (tile.numChildren == 0) {
			removeChild(tile);
		}
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
	
	public function move(distanceX:Int, distanceY:Int):Void {
		plus.move(distanceX, distanceY);
	}
}