package;
import WorldItem.WorldItemTickEvent;
import openfl.events.Event;

class Animal extends WorldItem
{
	private var walkTicks:Int = 2;
	private var eatTicks:Int = 500;
	public var desiredX:Int = null;
	public var desiredY:Int = null;
	private var memories:Array<Array<Any>> = [];
	private var willEat:Array<String> = [];
	private var desiredFood:String = "";
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
	}
	
	public override function registerTickActions():Void {		
		// walking
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, walkTicks, moveTowardsDesiredCoordinates));
		
		// eating
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, eatTicks, function () {
			var shortestDistance:Float = null;
			var rememberedFood:Array<Array<Any>> = memories.filter(memory -> willEat.filter(food -> memory[0] == food).length > 0); // TODO: after upgrading to haxe ~4.1 refactor to array `contains` for efficiency
			for (i in 0...rememberedFood.length) {
				var distance:Float = Math.sqrt(Math.pow((tileX - cast rememberedFood[i][1]), 2) + Math.pow((tileY - cast rememberedFood[i][2]), 2));
				if (shortestDistance == null || distance < shortestDistance) {
					shortestDistance = distance;
					setDesiredCoordinates(rememberedFood[i][1], rememberedFood[i][2]);
					desiredFood = rememberedFood[i][0];
				}
			}
		}));
	}
	
	public function setDesiredCoordinates(tileX:Int = null, tileY:Int = null):Void {
		desiredX = tileX;
		desiredY = tileY;
	}
	
	private function moveTowardsDesiredCoordinates():Void {
		if (desiredX != null && desiredY != null) {
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
			requestNeighboringTiles();
		}
	}
	
	public override function respondToMove():Void {
		super.respondToMove();
		if (desiredX == tileX && desiredY == tileY) {
			setDesiredCoordinates();
			requestSelfTile();
		}
	}
	
	private function requestEat():Void {
		dispatchEvent(new AnimalEatEvent(AnimalEatEvent.REQUEST_EAT, this, desiredFood));
	}
	
	private function requestSelfTile():Void {
		dispatchEvent(new AnimalMoveEvent(AnimalMoveEvent.REQUEST_SELF_TILE, this));
	}
	
	public function respondToSelfTile(selfTile:WorldTile):Void {
		if (selfTile.containsItemOfClass(desiredFood)) {
			requestEat();
		}
	}
	
	private function requestNeighboringTiles():Void {
		dispatchEvent(new AnimalMoveEvent(AnimalMoveEvent.REQUEST_NEIGHBORING_TILES, this));
	}
	
	public function respondToNeighboringTiles(neighboringTiles:Array<Array<WorldTile>>):Void {		
		for (column in neighboringTiles) {
			for (tile in column) {
				for (food in willEat) {
					if (tile != null && tile.containsItemOfClass(food) && memories.filter(memory -> memory[0] == food && memory[1] == tile.tileX && memory[2] == tile.tileY).length == 0) {
						memories.push([food, tile.tileX, tile.tileY]);
					}
				}
			}
		}
	}
}

class AnimalMoveEvent extends Event {
	public static inline var REQUEST_RANDOM_EMPTY_COORDINATES_IN_BUILDING = "requestRandomEmptyCoordinatesInBuilding";
	public static inline var REQUEST_SELF_TILE = "requestSelfTile";
	public static inline var REQUEST_NEIGHBORING_TILES = "requestNeighboringTiles";
	public var animal:Animal;
	
	public function new(type:String, animal:Animal)
    {
		this.animal = animal;
        super(type, true, false);
    }
}

class AnimalEatEvent extends Event {
	public static inline var REQUEST_EAT = "requestEat";
	public var animal:Animal;
	public var foodClass:String;
	
	public function new(type:String, animal:Animal, foodClass:String)
    {
		this.animal = animal;
		this.foodClass = foodClass;
        super(type, true, false);
    }
}