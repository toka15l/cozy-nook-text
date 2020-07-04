package;
import openfl.display.MovieClip;
import openfl.events.Event;

class Tile extends MovieClip 
{
	public var tileX:Int = null;
	public var tileY:Int = null;
	private var items:Array<Item> = [];
	private var currentItemIndex:Int = 0;

	public function new() {
		super();
	}
	
	public function addItem(item:Item):Void {
		items.push(item);
		addChild(item);
		if (items.length > 1) {
			dispatchEvent(new TileEvent(TileEvent.REGISTER_CONTAINS_MULTIPLE_ITEMS));
			items[currentItemIndex].visible = false;
			currentItemIndex = items.length - 1;
		}
	}
	
	public function removeItem(item:Item):Void {
		if (items[currentItemIndex] == item) {
			cycleItems();			
		}	
		item.visible = true;
		items.remove(item);		
		removeChild(item);
		if (items.length < 2) {
			dispatchEvent(new TileEvent(TileEvent.DEREGISTER_CONTAINS_MULTIPLE_ITEMS));
		}
	}
	
	public function cycleItems():Void {
		items[currentItemIndex].visible = false;
		currentItemIndex++;
		if (currentItemIndex == items.length) {
			currentItemIndex = 0;
		}
		items[currentItemIndex].visible = true;
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