package;
import openfl.display.Sprite;
import openfl.events.Event;

class WorldTile extends Sprite 
{
	public var tileX:Int = null;
	public var tileY:Int = null;
	private var currentItemIndex:Int = 0;
	public var items:Array<WorldItem> = [];

	public function new() {
		super();
	}
	
	//================================================================================
    // UTILITIES
    //================================================================================
	public function containsItemOfClass(className:String):Bool {
		for (item in items) {
			var currentClass:Any = Type.getClass(item);
			if (Type.getClassName(currentClass) == className) {
				return true;
			}
			while (currentClass != WorldItem) {
				currentClass = Type.getSuperClass(currentClass);
				if (Type.getClassName(currentClass) == className) {
					return true;
				}
			}
		}
		return false;
	}
	
	//================================================================================
    // ITEM ADD/REMOVE
    //================================================================================
	public function addItem(item:WorldItem):Void {
		item.tileX = tileX;
		item.tileY = tileY;
		addChild(item);
		items.push(item);
		if (items.length > 1) {
			items[currentItemIndex].visible = false;
			currentItemIndex = items.length - 1;
			if (items.length == 2) {
				dispatchEvent(new TileEvent(TileEvent.REGISTER_CONTAINS_MULTIPLE_ITEMS));
			}
		}
	}
	
	public function removeItem(item:WorldItem):Void {
		if (items.length - 1 < 2) {
			dispatchEvent(new TileEvent(TileEvent.DEREGISTER_CONTAINS_MULTIPLE_ITEMS));
		}
		// removing the item that is before the current item index requires adjustment
		var shouldAdjustCurrentItemIndex:Bool = false;
		for (i in 0...items.length) {
			if (items[i] == item) {
				if (i < currentItemIndex) {
					shouldAdjustCurrentItemIndex = true;
				}
				break;
			}
		}
		// cycle items if removal item is currently displayed
		if (items[currentItemIndex] == item) {
			cycleItems();			
		}
		// remove item
		item.visible = true;
		items.remove(item);
		removeChild(item);
		
		// adjust current item index
		if (shouldAdjustCurrentItemIndex == true) {
			currentItemIndex--;
		}
	}
	
	//================================================================================
    // MULTIPLE ITEM CYCLING
    //================================================================================	
	public function cycleItems():Void {
		items[currentItemIndex].visible = false;
		currentItemIndex++;
		if (currentItemIndex >= items.length) {
			currentItemIndex = 0;
		}
		items[currentItemIndex].visible = true;
	}
	
	//================================================================================
    // TILE SELECT
    //================================================================================
	public function tileSelect():Void {
		if (items.length == 1) {
			items[0].itemSelect();
		}
		if (items.length > 1) {
			dispatchEvent(new TileEvent(TileEvent.TILE_SELECT, items));
		}
	}
}

class TileEvent extends Event {
	public static inline var REGISTER_CONTAINS_MULTIPLE_ITEMS = "registerContainsMultipleItems";
	public static inline var DEREGISTER_CONTAINS_MULTIPLE_ITEMS = "deregisterContainsMultipleItems";
	public static inline var TILE_SELECT = "tileSelect";
	public var items:Array<WorldItem> = null;
	
	public function new(type:String, items:Array<WorldItem> = null)
    {
		this.items = items;
        super(type, true, false);
    }
}