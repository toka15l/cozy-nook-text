package;
import menu.TargetAction;
import openfl.events.Event;
import menu.Menu;
import menu.SelfAction;

class WorldItem extends Item
{
	public var selfActions:Array<SelfAction>;
	public var targetActions:Array<TargetAction>;

	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
		
		this.selfActions = [];
		this.targetActions = [];
		
		var actionPickUp:SelfAction = new SelfAction(30, 0x00FF00);
		actionPickUp.selfActionFunction = this.pickUp;
		selfActions.push(actionPickUp);
	}
	
	public function move(distanceX:Int, distanceY:Int):Void {
		dispatchEvent(new ItemMoveEvent(ItemMoveEvent.MOVE, distanceX, distanceY));
	}
	
	public function removeFromTile():Void {
		var tile:WorldTile = cast this.parent;
		tile.removeItem(this);
	}
	
	public function itemSelect():Void {
		if (selfActions != null) {
			dispatchEvent(new ItemEvent(ItemEvent.SELECT, selfActions));
		}
	}
	
	public function pickUp():Void {
		dispatchEvent(new ItemEvent(ItemEvent.PICKUP));
	}
	
	public function drop():Void {
		dispatchEvent(new ItemEvent(ItemEvent.DROP));
	}
	
	public function registerTickActions():Void {
		// exists to be overridden
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

class ItemEvent extends Event {
	public static inline var PICKUP = "pickUp";
	public static inline var DROP = "drop";
	public static inline var SELECT = "select";
	public var selfActions:Array<SelfAction> = null;
	
	public function new(type:String, selfActions:Array<SelfAction> = null)
    {
		this.selfActions = selfActions;
        super(type, true, false);
    }
}

class ItemTickEvent extends Event {
	public static inline var REGISTER = "register";
	public static inline var DEREGISTER = "deregister";
	public var tickFrequency:Int;
	public var tickFunction:Void->Void;
	
	public function new(type:String, tickFrequency:Int = null, tickFunction:Void->Void = null)
	{
		this.tickFrequency = tickFrequency;
		this.tickFunction = tickFunction;
		super(type, true, false);
	}
}