package;
import WorldItem.WorldItemTickEvent;
import openfl.events.Event;

class Cat extends WorldItem
{
	public var desiredX:Int = null;
	public var desiredY:Int = null;
	
	public function new() {
		super(99);
	}
	
	public override function registerTickActions():Void {
		// cat gets bored, picks new random destination to walk to
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, 20, function () {
			dispatchEvent(new CatMoveEvent(CatMoveEvent.REQUEST_RANDOM_EMPTY_COORDINATES_IN_BUILDING, this));
		}));
		
		// cat walks
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, 1, function () {
			if (desiredX != null && desiredY != null && (desiredX != tileX || desiredY != tileY)) {
				var movementX:Int = 0;
				if (tileX > desiredX) {
					movementX = -1;
				} else if (tileX < desiredX) {
					movementX = 1;
				}
				var movementY:Int = 0;
				if (tileY > desiredY) {
					movementY = -1;
				} else if (tileY < desiredY) {
					movementY = 1;
				}
				move(movementX, movementY);
			}
			
			/*var tile:WorldTile = cast parent; // TODO: remove 'parent' usage - replace with event
			var world:World = cast tile.parent;
			var neighbors:Array<Array<WorldTile>> = world.getNeighbors(tile);
			if (neighbors[2][1] == null) {
				move(1, 0);
			}*/
		}));
	}
}

class CatMoveEvent extends Event {
	public static inline var REQUEST_RANDOM_EMPTY_COORDINATES_IN_BUILDING = "requestRandomEmptyCoordinatesInBuilding";
	public var cat:Cat;
	
	public function new(type:String, cat:Cat)
    {
		this.cat = cat;
        super(type, true, false);
    }
}