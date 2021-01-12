package;
import openfl.Lib.*;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import WorldItem.ItemEvent;
import WorldItem.ItemMoveEvent;
import WorldTile.TileEvent;
import Container.ContainerEvent;

class World extends Board
{
	private static inline var ITEM_CYCLE_INTERVAL:Int = 800;
	private var building:Building = null;
	private var multipleSelect:Bool = false;
	private var tilesContainingMultipleItems:Array<WorldTile> = [];
	private var cursor:Sprite = null;
	private var carriedItems:Array<WorldItem> = [];
	private var cursorX:Int = 0;
	private var cursorY:Int = 0;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
		
		// event listeners
		addEventListener(ItemMoveEvent.MOVE, itemMove);
		addEventListener(TileEvent.REGISTER_CONTAINS_MULTIPLE_ITEMS, registerContainsMultipleItems);
		addEventListener(TileEvent.DEREGISTER_CONTAINS_MULTIPLE_ITEMS, deregisterContainsMultipleItems);
		addEventListener(ContainerEvent.REMOVE_ITEM_FROM_CONTAINER, removeItemFromContainer);
		addEventListener(ItemEvent.PICKUP, pickUpItem);
		
		// test dwarf
		addItemToTile(new Dwarf(), 3, 3);
		
		// cursor
		cursor = new Sprite();
		cursor.addChild(new Bitmap(spriteBitmapData.getBitmapDataForCharCode(219)));
		addChild(cursor);
		
		// test existing building
		var existingBuilding:Building = new Building(2, 2, 18, 8);
		for (item in existingBuilding.items) {
			addItemToTile(item[0], item[1], item[2]);
		}
		
		// test barrel
		var testBarrel:Barrel = new Barrel();
		var pickles:ContainerObject = new ContainerObject();
		pickles.itemClass = Pickle;
		pickles.name = "Pickles";
		pickles.count = 34;
		testBarrel.addItem(pickles);
		addItemToTile(testBarrel, 4, 4);
		
		// test pickle
		addItemToTile(new Pickle(), 6, 4);
		
		// test butcher block
		addItemToTile(new ButcherBlock(), 4, 3);
		addItemToTile(new Pickle(), 4, 3);
		
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
		var item:WorldItem = cast e.target;
		var tile:WorldTile = cast item.parent;		
		addItemToTile(item, tile.tileX + e.distanceX, tile.tileY + e.distanceY);
		removeItemFromTile(item, tile);
	}
	
	public function move(distanceX:Int, distanceY:Int):Void {
		cursorX += distanceX;
		cursorY += distanceY;
		cursor.x = cursorX * SpriteBitmapData.SPRITE_WIDTH;
		cursor.y = cursorY * SpriteBitmapData.SPRITE_HEIGHT;
		if (multipleSelect == true) {
			for (item in building.items) {
				var itemOject:WorldItem = cast item[0];
				var itemTile:WorldTile = cast itemOject.parent;
				removeItemFromTile(itemOject, itemTile);
			}
			building.changeEnd(cursorX, cursorY);
			for (item in building.items) {
				addItemToTile(item[0], item[1], item[2]);
			}
		}
	}
	
	//================================================================================
    // ITEM PICKUP
    //================================================================================	
	private function removeItemFromContainer(e:ContainerEvent):Void {
		var item:WorldItem = cast e.target;
		var tile:WorldTile = cast item.parent;
		addItemToTile(e.item, tile.tileX, tile.tileY);
		carriedItems.push(e.item);
	}
	
	private function pickUpItem(e:ItemEvent):Void {
		carriedItems.push(e.target);
	}
	
	//================================================================================
    // MULTIPLE TILE OBJECTS
    //================================================================================	
	public function multipleTileSelect():Void {
		if (multipleSelect == false) {
			multipleSelect = true;
			building = new Building(cursorX, cursorY);
			for (item in building.items) {
				addItemToTile(item[0], item[1], item[2]);
			}
		} else {
			multipleSelect = false;
		}
	}
	
	//================================================================================
    // TILE SELECT
    //================================================================================
	public function tileSelect():Void {
		if (carriedItems.length > 0) {
			carriedItems = [];
		} else {
			var tile:WorldTile = cast getChildByName("tile_" + cursorX + "_" + cursorY);
			if (tile != null) {
				tile.tileSelect();
			}
		}
	}
	
	//================================================================================
    // ITEM ADD/REMOVE
    //================================================================================
	private function addItemToTile(item:WorldItem, x:Int, y:Int):Void {
		var tile:WorldTile = cast getChildByName("tile_" + x + "_" + y);
		if (tile == null) {
			tile = new WorldTile();
			tile.tileX = x;
			tile.tileY = y;
			tile.x = x * SpriteBitmapData.SPRITE_WIDTH;
			tile.y = y * SpriteBitmapData.SPRITE_HEIGHT;
			tile.name = "tile_" + x + "_" + y;
			addChild(tile);
		}
		tile.addItem(item);
		item.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(item.spriteCharCode));
	}
	
	private function removeItemFromTile(item:WorldItem, tile:WorldTile):Void {
		tile.removeItem(item);
		if (tile.numChildren == 0) {
			removeChild(tile);
		}
	}
	
	public function emptyAllTiles():Void {
		while (numChildren > 0) {
			var tile:WorldTile = cast getChildAt(0);
			for (item in tile.items) {
				removeItemFromTile(item, tile);
			}
		}
	}
	
	//================================================================================
    // CURSOR
    //================================================================================
	public function showCursor(show:Bool):Void {
		cursor.visible = show;
	}
}