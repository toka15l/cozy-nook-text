package;
import WorldItem.WorldItemTickEvent;
import openfl.events.Event;

class Animal extends WorldItem
{
	public var desiredX:Int = null;
	public var desiredY:Int = null;
	private var memories:Array<Array<Any>> = [];
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
	}
	
	public override function registerTickActions():Void {		
		// cat walks
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, 1, moveTowardsDesiredCoordinates));
	}
	
	public function setDesiredCoordinates(tileX:Int, tileY:Int):Void {
		desiredX = tileX;
		desiredY = tileY;
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
		dispatchEvent(new AnimalMoveEvent(AnimalMoveEvent.REQUEST_NEIGHBORS, this));
	}
	
	public function respondToNeighbors(neighbors:Array<Array<WorldTile>>):Void {		
		for (column in neighbors) {
			for (tile in column) {
				if (tile != null && tile.containsItemOfClass('Pickle') && memories.filter(memory -> memory[0] == 'Pickle' && memory[1] == tile.tileX && memory[2] == tile.tileY).length == 0) {
					memories.push(['Pickle', tile.tileX, tile.tileY]);
				}
			}
		}
	}
}

class AnimalMoveEvent extends Event {
	public static inline var REQUEST_RANDOM_EMPTY_COORDINATES_IN_BUILDING = "requestRandomEmptyCoordinatesInBuilding";
	public static inline var REQUEST_NEIGHBORS = "requestNeighbors";
	public var animal:Animal;
	
	public function new(type:String, animal:Animal)
    {
		this.animal = animal;
        super(type, true, false);
    }
}