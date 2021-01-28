package;
import openfl.events.Event;
import menu.SelfAction;
import menu.TargetAction;
import WorldItem.WorldItemEvent;

class Container extends WorldItem
{
	public var contents:Array<ContainerObject> = [];
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
		
		var actionRemoveItem:SelfAction = new SelfAction(24, 0x00FF00);
		actionRemoveItem.selfActionFunction = function ():Void {
			if (contents.length > 0) {
				contents[0].count--; // TODO: add ability to select which container object to remove item from
				var item:WorldItem = Type.createInstance(contents[0].itemClass, []);
				if (contents[0].count == 0) {
					contents.splice(0, 1);
				}
				dispatchEvent(new ContainerEvent(ContainerEvent.REMOVE_ITEM_FROM_CONTAINER, item, this));
			}
		}
		selfActions.push(actionRemoveItem);
		
		var actionInsertItem:TargetAction = new TargetAction(70, 0xFF0000);
		actionInsertItem.targetAction = function (dropItem:WorldItem):Void {
			var currentClass:Any = Type.getClass(dropItem);
			var exists:Bool = false;
			for (containerObject in contents) {
				if (containerObject.itemClass == currentClass) {
					exists = true;
					containerObject.count++;
					break;
				}
			}
			if (exists == false) {
				var containerObject:ContainerObject = new ContainerObject();
				containerObject.itemClass = currentClass;
				containerObject.count = 1;
				addItem(containerObject);
			}
			dropItem.removeFromTile();
		}
		actionInsertItem.applicableClasses = ['WorldItem'];
		targetActions.push(actionInsertItem);
	}
	
	public function addItem(item:ContainerObject):Void {
		contents.push(item);
	}
}

class ContainerEvent extends WorldItemEvent {
	public static inline var REMOVE_ITEM_FROM_CONTAINER = "removeItemFromContainer";
	public var container:Container;
	
	public function new(type:String, item:WorldItem, container:Container)
    {
		this.container = container;
        super(type, item);
    }
}