package;
import WorldItem.WorldItemTickEvent;
import openfl.events.Event;

class Cat extends WorldItem
{
	public var desiredX:Int = null;
	public var desiredY:Int = null;
	private var memories:Array<Array<Any>> = [];
	
	public function new() {
		super(99);
	}
	
	public override function registerTickActions():Void {
		// cat gets bored, picks new random destination to walk to
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, 20, function () {
			dispatchEvent(new CatMoveEvent(CatMoveEvent.REQUEST_RANDOM_EMPTY_COORDINATES_IN_BUILDING, this));
		}));
		
		// cat walks
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, 1, moveTowardsDesiredCoordinates));
		
		// cat gets hungry
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, 240, function () {
			trace("hungry");
			var shortestDistance:Float = null;
			var rememberedPickles:Array<Array<Any>> = memories.filter(memory -> memory[0] == 'Pickle');
			for (i in 0...rememberedPickles.length) {
				var distance:Float = Math.sqrt(Math.pow(rememberedPickles[i][1], 2) + Math.pow(rememberedPickles[i][2], 2));
				if (shortestDistance == null || distance < shortestDistance) {
					shortestDistance = distance;
					desiredX = rememberedPickles[i][1];
					desiredY = rememberedPickles[i][2];
				}
			}
		}));
	}
	
	private function moveTowardsDesiredCoordinates():Void {
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
			lookAround();
		}
	}
	
	private function lookAround():Void {
		dispatchEvent(new CatMoveEvent(CatMoveEvent.REQUEST_NEIGHBORS, this));
	}
	
	public function respondToNeighbors(neighbors:Array<Array<WorldTile>>):Void {		
		for (column in neighbors) {
			for (tile in column) {
				if (tile != null && tile.containsItemOfClass('Pickle')) {
					var exists:Bool = false;
					for (memory in memories) {
						if (memory[0] == 'Pickle' && memory[1] == tile.tileX && memory[2] == tile.tileY) {
							exists = true;
							break;
						}
					}
					if (exists == false) {
						memories.push(['Pickle', tile.tileX, tile.tileY]);
					}
				}
			}
		}
		trace(memories.toString());
	}
}

class CatMoveEvent extends Event {
	public static inline var REQUEST_RANDOM_EMPTY_COORDINATES_IN_BUILDING = "requestRandomEmptyCoordinatesInBuilding";
	public static inline var REQUEST_NEIGHBORS = "requestNeighbors";
	public var cat:Cat;
	
	public function new(type:String, cat:Cat)
    {
		this.cat = cat;
        super(type, true, false);
    }
}