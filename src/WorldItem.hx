package;
import openfl.events.Event;
import menu.Menu;
import menu.Action;

class WorldItem extends Item
{
	public var actions:Array<Action>;

	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
		
		this.actions = [];
		
		var actionPickUp:Action = new Action();
		actionPickUp.string = "Pick Up";
		actionPickUp.action = this.pickUp; 
		actions.push(actionPickUp);
	}
	
	public function move(distanceX:Int, distanceY:Int):Void {
		dispatchEvent(new ItemMoveEvent(ItemMoveEvent.MOVE, distanceX, distanceY));
	}
	
	public function itemSelect():Void {
		if (actions != null) {
			dispatchEvent(new ItemSelectEvent(ItemSelectEvent.REQUEST_ACTIONS, actions));
		}
	}
	
	public function pickUp():Void {
		dispatchEvent(new ItemEvent(ItemEvent.PICKUP));
	}
}

class ItemMoveEvent extends Event {
	public static inline var MOVE = "move";
	public var distanceX:Int;
	public var distanceY:Int;
	
	public function new(type:String, distanceX:Int, distanceY:Int)
    {
		this.distanceX = distanceX;
		this.distanceY = distanceY;
        super(type, true, false);
    }
}

class ItemSelectEvent extends Event {
	public static inline var REQUEST_ACTIONS = "requestActions";
	public var actions:Array<Action> = null;
	
	public function new(type:String, actions:Array<Action>)
    {
		this.actions = actions;
        super(type, true, false);
    }
}

class ItemEvent extends Event {
	public static inline var PICKUP = "pickUp";
	
	public function new(type:String)
    {
        super(type, true, false);
    }
}