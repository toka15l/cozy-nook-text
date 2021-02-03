package;
import openfl.Lib.*;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import WorldItem.WorldItemActionEvent;
import WorldItem.WorldItemMoveEvent;
import WorldItem.WorldItemTickEvent;
import WorldTile.TileEvent;
import Container.ContainerEvent;
import Animal.AnimalMoveEvent;
import Animal.AnimalEatEvent;

class World extends Board
{
	private static inline var ITEM_CYCLE_INTERVAL:Int = 800;
	private static inline var TICK_INTERVAL:Int = 250;
	private var building:Building = null;
	private var multipleSelect:Bool = false;
	private var tilesContainingMultipleItems:Array<WorldTile> = [];
	private var cursor:Sprite = null;
	private var carriedItems:Array<WorldItem> = [];
	private var cursorX:Int = 0;
	private var cursorY:Int = 0;
	private var tickActions:Map<Int, Array<Dynamic>> = [];
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
		
		// event listeners
		addEventListener(WorldItemMoveEvent.MOVE, itemMove);
		addEventListener(TileEvent.REGISTER_CONTAINS_MULTIPLE_ITEMS, registerContainsMultipleItems);
		addEventListener(TileEvent.DEREGISTER_CONTAINS_MULTIPLE_ITEMS, deregisterContainsMultipleItems);
		addEventListener(ContainerEvent.REMOVE_ITEM_FROM_CONTAINER, removeItemFromContainer);
		addEventListener(WorldItemActionEvent.PICKUP, pickUpItem);
		addEventListener(WorldItemTickEvent.REGISTER, registerTickEvent);
		addEventListener(WorldItemTickEvent.DEREGISTER, deregisterTickEvent);
		addEventListener(AnimalMoveEvent.REQUEST_RANDOM_EMPTY_COORDINATES_IN_BUILDING, requestRandomCoordinatesInBuilding);
		addEventListener(AnimalMoveEvent.REQUEST_SELF, requestSelf);
		addEventListener(AnimalMoveEvent.REQUEST_NEIGHBORS, requestNeighbors);
		addEventListener(AnimalEatEvent.REQUEST_EAT, requestEat);
		
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
		pickles.count = 1;
		testBarrel.addItem(pickles);
		addItemToTile(testBarrel, 4, 4);
		
		// test pickle
		addItemToTile(new Pickle(), 6, 4);
		
		// test fish
		addItemToTile(new Fish(), 8, 4);
		
		// test butcher block
		addItemToTile(new ButcherBlock(), 4, 3);
		addItemToTile(new Pickle(), 4, 3);
		
		// test cat
		addItemToTile(new Cat(), 7, 7);
		
		// multiple item cycle interval
		setInterval(cycleItems, ITEM_CYCLE_INTERVAL);
		
		// set time tick
		setInterval(tick, TICK_INTERVAL);
	}
	
	//================================================================================
    // UTILITIES
    //================================================================================
	private function getTileAt(tileX:Int, tileY:Int):WorldTile {
		return cast getChildByName("tile_" + tileX + "_" + tileY);
	}
	
	//================================================================================
    // TIME
    //================================================================================
	private function tick():Void {
		for (key in tickActions.keys()) {
			if (tickActions[key][0] == key) {
				tickActions[key][0] = 1;
				for (i in 1...tickActions[key].length) {
					tickActions[key][i]();
				}
			} else {
				tickActions[key][0]++;
			}
		}
	}
	
	private function registerTickEvent(e:WorldItemTickEvent):Void {
		if (tickActions.exists(e.tickFrequency)) {
			tickActions[e.tickFrequency].push(e.tickFunction);
		} else {
			var tickArray:Array<Dynamic> = [1, e.tickFunction];
			tickActions[e.tickFrequency] = tickArray;
		}
	}
	
	private function deregisterTickEvent(e:WorldItemTickEvent):Void {
		trace("deregister tick event"); // TODO: add tick event de-registering
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
	private function itemMove(e:WorldItemMoveEvent):Void {
		removeItemFromTile(e.item, getTileAt(e.item.tileX, e.item.tileY));
		addItemToTile(e.item, e.item.tileX + e.distanceX, e.item.tileY + e.distanceY);
		e.item.respondToMove();
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
		for (item in carriedItems) {
			item.move(distanceX, distanceY);
		}
	}
	
	private function getRoomBoundariesContainingOrigin(tileX:Int, tileY:Int):Array<Int> {
		var boundaries:Array<Int> = [null, null, null, null]; // [top, right, bottom, left]
		var distanceFromOrigin:Int = 0;
		while (boundaries.indexOf(null) != -1) {
			distanceFromOrigin++;
			boundaries[0] = boundaries[0] == null ? boundarycheck(tileX, tileY - distanceFromOrigin, "y", 1) : boundaries[0];
			boundaries[1] = boundaries[1] == null ? boundarycheck(tileX + distanceFromOrigin, tileY, "x", -1) : boundaries[1];
			boundaries[2] = boundaries[2] == null ? boundarycheck(tileX, tileY + distanceFromOrigin, "y", -1) : boundaries[2];
			boundaries[3] = boundaries[3] == null ? boundarycheck(tileX - distanceFromOrigin, tileY, "x", 1) : boundaries[3];
		}
		return boundaries;
	}
	
	private function boundarycheck(tileX:Int, tileY:Int, axis:String, oppositeDirection:Int):Int {
		var checkTile:WorldTile = getTileAt(tileX, tileY);
		if (checkTile != null && checkTile.containsItemOfClass('Wall') == true) {
			return axis == "x" ? tileX + oppositeDirection : tileY + oppositeDirection;
		}
		return null;
	}
	
	//================================================================================
    // ANIMAL EVENT HANDLING
    //================================================================================
	public function requestSelf(e:AnimalMoveEvent):Void {
		e.animal.respondToSelf(getTileAt(e.animal.tileX, e.animal.tileY));
	}
	
	public function requestNeighbors(e:AnimalMoveEvent):Void {
		var neighbors:Array<Array<WorldTile>> = [];
		for (x in -1...2) {
			var currentColumn:Array<WorldTile> = [];
			for (y in -1...2) {
				currentColumn.push(getTileAt(e.animal.tileX + x, e.animal.tileY + y));
			}
			neighbors.push(currentColumn);
		}
		e.animal.respondToNeighbors(neighbors);
	}
	
	private function requestRandomCoordinatesInBuilding(e:AnimalMoveEvent):Void {
		var boundaries:Array<Int> = getRoomBoundariesContainingOrigin(e.animal.tileX, e.animal.tileY);
		e.animal.setDesiredCoordinates(Math.floor(Math.random() * (boundaries[1] - boundaries[3] + 1) + boundaries[3]), Math.floor(Math.random() * (boundaries[2] - boundaries[0] + 1) + boundaries[0]));
	}
	
	public function requestEat(e:AnimalEatEvent):Void {
		var tile:WorldTile = getTileAt(e.animal.tileX, e.animal.tileY);
		if (tile.containsItemOfClass(e.foodClass)) {
			var foodItem:WorldItem = tile.getContainedItemOfClass(e.foodClass);
			if (foodItem != null) {
				tile.removeItem(foodItem);
			}
		}
	}
	
	//================================================================================
    // ITEM PICKUP
    //================================================================================	
	private function removeItemFromContainer(e:ContainerEvent):Void {
		addItemToTile(e.item, e.container.tileX, e.container.tileY);
		carriedItems.push(e.item);
	}
	
	private function pickUpItem(e:WorldItemActionEvent):Void {
		carriedItems.push(e.item);
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
			for (item in carriedItems) {
				item.drop();
			}			
			carriedItems = [];
		} else {
			var tile:WorldTile = getTileAt(cursorX, cursorY);
			if (tile != null) {
				tile.tileSelect();
			}
		}
	}
	
	//================================================================================
    // ITEM ADD/REMOVE
    //================================================================================
	private function addItemToTile(item:WorldItem, tileX:Int, tileY:Int):Void {
		var tile:WorldTile = getTileAt(tileX, tileY);
		if (tile == null) {
			tile = new WorldTile();
			tile.tileX = tileX;
			tile.tileY = tileY;
			tile.x = tileX * SpriteBitmapData.SPRITE_WIDTH;
			tile.y = tileY * SpriteBitmapData.SPRITE_HEIGHT;
			tile.name = "tile_" + tileX + "_" + tileY;
			addChild(tile);
		}
		tile.addItem(item);
		item.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(item.spriteCharCode));
		if (item.tickActionsRegistered == false) {
			item.tickActionsRegistered = true;
			item.registerTickActions();
		}
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