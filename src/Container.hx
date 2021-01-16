package;
import openfl.events.Event;
import menu.Action;
import menu.DropAction;

class Container extends WorldItem
{
	public var contents:Array<ContainerObject> = [];
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
		
		var actionRemoveItem:Action = new Action(24, 0x00FF00);
		actionRemoveItem.action = this.removeItem;
		actions.push(actionRemoveItem);
		
		var actionInsertItem:DropAction = new DropAction(70, 0xFF0000);
		actionInsertItem.dropAction = function (dropItem:WorldItem):Void {
			trace("insert item " + dropItem);
		}
		actionInsertItem.applicableClasses = ['WorldItem'];
		dropActions.push(actionInsertItem);
	}
	
	public function addItem(item:ContainerObject):Void {
		contents.push(item);
	}
	
	public function removeItem():Void {
		if (contents.length > 0) {
			if (contents[0].count > 1) {
				contents[0].count--;
				var item:WorldItem = Type.createInstance(contents[0].itemClass, []);
				dispatchEvent(new ContainerEvent(ContainerEvent.REMOVE_ITEM_FROM_CONTAINER, item));
			}
		}
	}
}

class ContainerEvent extends Event {
	public static inline var REMOVE_ITEM_FROM_CONTAINER = "removeItemFromContainer";
	public var item:WorldItem;
	
	public function new(type:String, item:WorldItem)
    {
		this.item = item;
        super(type, true, false);
    }
}