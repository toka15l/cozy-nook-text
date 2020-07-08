package;
import openfl.display.Bitmap;
import Item.ItemMoveEvent;
import Tile.TileEvent;
import Container.ContainerEvent;
import openfl.Lib.*;
import openfl.display.Sprite;

class Board extends Sprite
{
	private static inline var ZOOM_FACTOR:Int = 1;
	private static inline var INITIAL_SCALE:Int = 3;
	private static inline var ITEM_CYCLE_INTERVAL:Int = 800;
	public var spriteBitmapData:SpriteBitmapData;
	private var cursor:Plus = null;
	private var tilesContainingMultipleItems:Array<Tile> = [];
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super();
		
		// set initial scale (zoom)
		scaleX = scaleY = INITIAL_SCALE;
		
		// initialize sprite bitmap data
		this.spriteBitmapData = spriteBitmapData;
		
		// event listeners
		addEventListener(ItemMoveEvent.MOVE, itemMove);
		addEventListener(TileEvent.REGISTER_CONTAINS_MULTIPLE_ITEMS, registerContainsMultipleItems);
		addEventListener(TileEvent.DEREGISTER_CONTAINS_MULTIPLE_ITEMS, deregisterContainsMultipleItems);
		addEventListener(ContainerEvent.REMOVE_ITEM_FROM_CONTAINER, pickUpItem);
		
		
		// multiple item cycle interval
		setInterval(cycleItems, ITEM_CYCLE_INTERVAL);	
	}
	
	//================================================================================
    // MULTIPLE ITEM CYCLING
    //================================================================================	
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
	
	//================================================================================
    // ITEM MOVING
    //================================================================================
	private function itemMove(e:ItemMoveEvent):Void {
		var item:Item = cast e.target;
		var tile:Tile = cast item.parent;
		addItemsToTile([item], tile.tileX + e.distanceX, tile.tileY + e.distanceY);
		removeItemsFromTile([item], tile);
	}
	
	public function move(distanceX:Int, distanceY:Int):Void {
		cursor.move(distanceX, distanceY);
	}
	
	//================================================================================
    // ITEM PICKUP
    //================================================================================
	private function pickUpItem(e:ContainerEvent):Void {
		var item:Item = cast e.target;
		var tile:Tile = cast item.parent;
		addItemsToTile([e.item], tile.tileX, tile.tileY);
	}
	
	//================================================================================
    // ITEM ADD/REMOVE
    //================================================================================
	private function addItemsToTile(items:Array<Item>, x:Int, y:Int):Void {
		var tile:Tile = cast getChildByName("tile_" + x + "_" + y);
		if (tile == null) {
			tile = new Tile();
			tile.tileX = x;
			tile.tileY = y;
			tile.x = x * SpriteBitmapData.SPRITE_WIDTH;
			tile.y = y * SpriteBitmapData.SPRITE_HEIGHT;
			tile.name = "tile_" + x + "_" + y;
			addChild(tile);
		}
		for (item in items) {
			tile.addItem(item);
			item.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(item.spriteCharCode));
		}
	}
	
	private function removeItemsFromTile(items:Array<Item>, tile:Tile):Void {
		for (item in items) {
			tile.removeItem(item);
			if (tile.numChildren == 0) {
				removeChild(tile);
			}
		}
	}
	
	public function emptyAllTiles():Void {
		while (numChildren > 0) {
			var tile:Tile = cast getChildAt(0);
			removeItemsFromTile(tile.items, tile);
		}
	}
	
	public function isEmpty():Bool {
		if (numChildren == 0) {
			return true;
		}
		return false;
	}
	
	//================================================================================
    // TILE SELECT
    //================================================================================
	public function tileSelect():Void {
		var tile:Tile = cast cursor.parent;
		tile.tileSelect();
	}
	
	//================================================================================
    // ZOOM
    //================================================================================
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
}