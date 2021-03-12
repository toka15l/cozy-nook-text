package;
import menu.TargetAction;
import openfl.events.Event;
import menu.SelfAction;

class WorldItem extends Item
{
	public var tileX:Int = null;
	public var tileY:Int = null;
	public var selfActions:Array<SelfAction>;
	public var targetActions:Array<TargetAction>;
	public var tickActionsRegistered:Bool = false;

	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
		
		this.selfActions = [];
		this.targetActions = [];
		
		var actionPickUp:SelfAction = new SelfAction(30, 0x00FF00);
		actionPickUp.selfActionFunction = this.pickUp;
		selfActions.push(actionPickUp);
	}
	
	public function move(distanceX:Int, distanceY:Int):Void {
		dispatchEvent(new WorldItemMoveEvent(WorldItemMoveEvent.MOVE, this, distanceX, distanceY));
	}
	
	public function respondToMove():Void {
		// exists to be overridden
	}
	
	public function removeFromTile():Void {
		var tile:WorldTile = cast this.parent;
		tile.removeItem(this);
	}
	
	public function itemSelect():Void {
		if (selfActions != null) {
			dispatchEvent(new WorldItemActionEvent(WorldItemActionEvent.SELECT, this, selfActions));
		}
	}
	
	public function pickUp():Void {
		dispatchEvent(new WorldItemActionEvent(WorldItemActionEvent.PICKUP, this));
	}
	
	public function drop():Void {
		dispatchEvent(new WorldItemActionEvent(WorldItemActionEvent.DROP, this));
	}
	
	public function registerTickActions():Void {
		// exists to be overridden
	}
}

class WorldItemEvent extends Event {
	public var item:WorldItem;
	
	public function new(type:String, item:WorldItem)
    {
		this.item = item;
        super(type, true, false);
    }
}

class WorldItemMoveEvent extends WorldItemEvent {
	public static inline var MOVE = "move";
	public var distanceX:Int;
	public var distanceY:Int;
	
	public function new(type:String, item:WorldItem, distanceX:Int = null, distanceY:Int = null)
    {
		this.distanceX = distanceX;
		this.distanceY = distanceY;
        super(type, item);
    }
}

class WorldItemActionEvent extends WorldItemEvent {
	public static inline var PICKUP = "pickUp";
	public static inline var DROP = "drop";
	public static inline var SELECT = "select";
	public var selfActions:Array<SelfAction> = null;
	
	public function new(type:String, item:WorldItem, selfActions:Array<SelfAction> = null)
    {
		this.selfActions = selfActions;
        super(type, item);
    }
}

class WorldItemTickEvent extends WorldItemEvent {
	public static inline var REGISTER = "register";
	public static inline var DEREGISTER = "deregister";
	public var tickFrequency:Int;
	public var tickFunction:Void->Void;
	
	public function new(type:String, item:WorldItem, tickFrequency:Int = null, tickFunction:Void->Void = null)
	{
		this.tickFrequency = tickFrequency;
		this.tickFunction = tickFunction;
		super(type, item);
	}
}