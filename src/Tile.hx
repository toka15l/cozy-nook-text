package;
import openfl.display.Sprite;
import openfl.events.Event;

class Tile extends Sprite 
{
	public var tileX:Int = null;
	public var tileY:Int = null;
	public var items:Array<Item> = [];
	private var currentItemIndex:Int = 0;

	public function new() {
		super();
	}
	
	//================================================================================
    // ITEM ADD/REMOVE
    //================================================================================
	public function addItem(item:Item):Void {
		items.push(item);
		addChild(item);
		if (items.length > 1) {
			items[currentItemIndex].visible = false;
			currentItemIndex = items.length - 1;
			if (items.length == 2) {
				dispatchEvent(new TileEvent(TileEvent.REGISTER_CONTAINS_MULTIPLE_ITEMS));
			}
		}
	}
	
	public function removeItem(item:Item):Void {
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
		for (item in items) {
			if (Type.getClass(item) != Plus) {
				item.itemSelect();
			}
		}
	}
}

class TileEvent extends Event {
	public static inline var REGISTER_CONTAINS_MULTIPLE_ITEMS = "registerContainsMultipleItems";
	public static inline var DEREGISTER_CONTAINS_MULTIPLE_ITEMS = "deregisterContainsMultipleItems";
	
	public function new(type:String)
    {
        super(type, true, false);
    }
}