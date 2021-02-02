package;
import WorldItem.WorldItemTickEvent;
import Animal.AnimalMoveEvent;

class Cat extends Animal
{	
	public function new() {
		super(99);
	}
	
	public override function registerTickActions():Void {
		super.registerTickActions();

		// cat gets bored, picks new random destination to walk to
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, 20, function () {
			dispatchEvent(new AnimalMoveEvent(AnimalMoveEvent.REQUEST_RANDOM_EMPTY_COORDINATES_IN_BUILDING, this));
		}));
		
		// cat gets hungry
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, 240, function () {
			var shortestDistance:Float = null;
			var rememberedPickles:Array<Array<Any>> = memories.filter(memory -> memory[0] == 'Pickle');
			for (i in 0...rememberedPickles.length) {
				var distance:Float = Math.sqrt(Math.pow((tileX - cast rememberedPickles[i][1]), 2) + Math.pow((tileY - cast rememberedPickles[i][2]), 2));
				if (shortestDistance == null || distance < shortestDistance) {
					shortestDistance = distance;
					desiredX = rememberedPickles[i][1];
					desiredY = rememberedPickles[i][2];
					// TODO: cat eats food
				}
			}
		}));
	}
}