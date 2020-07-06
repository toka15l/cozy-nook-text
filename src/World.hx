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
	private var bitmaps:SpriteBitmapData = null;
	private var tiles:Array<Tile> = [];
	private var cursor:Plus = null;
	private var selectionStartIndicator:Asterisk = null;
	private var tilesContainingMultipleItems:Array<Tile> = [];
	private var selectionStartTile:Tile = null;
	private var building:Building = null;
	
	public function new() {
		super();
		
		// set initial scale (zoom)
		scaleX = scaleY = INITIAL_SCALE;
		
		// initialize sprite bitmap data
		bitmaps = new SpriteBitmapData();
		
		// event listeners
		addEventListener(ItemEvent.MOVE, itemMove);
		addEventListener(TileEvent.REGISTER_CONTAINS_MULTIPLE_ITEMS, registerContainsMultipleItems);
		addEventListener(TileEvent.DEREGISTER_CONTAINS_MULTIPLE_ITEMS, deregisterContainsMultipleItems);
		
		// multiple item cycle interval
		setInterval(cycleItems, ITEM_CYCLE_INTERVAL);
		
		// test dwarf
		addItemsToTile([new Dwarf()], 1, 2);
		
		// test cursor
		cursor = new Plus();
		addItemsToTile([cursor], 5, 5);
		
		// test building
		var test:Building = new Building(2, 2, 5, 5);
		for (item in test.items) {
			addItemsToTile([item[0]], item[1], item[2]);
		}		
	}
	
	//================================================================================
    // MULTIPLE TILE OBJECTS
    //================================================================================	
	public function multipleTileSelect():Void {
		if (selectionStartTile == null) {
			selectionStartTile = cast cursor.parent;
			building = new Building(selectionStartTile.tileX, selectionStartTile.tileY);
			for (item in building.items) {
				addItemsToTile([item[0]], item[1], item[2]);
			}
		} else {
			selectionStartTile = null;
		}
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
	private function itemMove(e:ItemEvent):Void {
		var item:Item = cast e.target;
		var tile:Tile = cast item.parent;
		addItemsToTile([item], tile.tileX + e.distanceX, tile.tileY + e.distanceY);
		removeItemsFromTile([item], tile);
	}
	
	public function move(distanceX:Int, distanceY:Int):Void {
		cursor.move(distanceX, distanceY);
		if (selectionStartTile != null) {
			var tile:Tile = cast cursor.parent;
			for (item in building.items) {
				var itemOject:Item = cast item[0];
				var itemTile:Tile = cast itemOject.parent;
				removeItemsFromTile([itemOject], itemTile);
			}
			building.changeEnd(tile.tileX, tile.tileY);
			for (item in building.items) {
				addItemsToTile([item[0]], item[1], item[2]);
			}
		}
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
			item.setBitmapData(bitmaps.getBitmapDataForCoordinates(item.spriteX, item.spriteY));
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