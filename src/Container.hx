package;
import openfl.events.Event;
import menu.Action;

class Container extends Item
{
	public var contents:Array<ContainerObject> = [];
	
	public function new() {
		actions = [];
		var actionRemoveItem:Action = new Action();
		actionRemoveItem.string = "Remove Item";
		actionRemoveItem.action = this.removeItem;
		actions.push(actionRemoveItem);
		
		super();
	}
	
	public function addItem(item:ContainerObject):Void {
		contents.push(item);
	}
	
	public function removeItem():Void {
		if (contents.length > 0) {
			if (contents[0].count > 1) {
				contents[0].count--;
				var item:Item = Type.createInstance(contents[0].itemClass, []);
				dispatchEvent(new ContainerEvent(ContainerEvent.REMOVE_ITEM_FROM_CONTAINER, item));
			}
		}
	}
}

class ContainerEvent extends Event {
	public static inline var REMOVE_ITEM_FROM_CONTAINER = "removeItemFromContainer";
	public var item:Item;
	
	public function new(type:String, item:Item)
    {
		this.item = item;
        super(type, true, false);
    }
}