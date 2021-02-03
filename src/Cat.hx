package;
import WorldItem.WorldItemTickEvent;
import Animal.AnimalMoveEvent;

class Cat extends Animal
{
	public function new() {
		super(99);
		walkTicks = 1;
		eatTicks = 240;
		willEat = ['Fish'];
	}
	
	public override function registerTickActions():Void {
		super.registerTickActions();

		// cat gets bored, picks new random destination to walk to
		dispatchEvent(new WorldItemTickEvent(WorldItemTickEvent.REGISTER, this, 20, function () {
			dispatchEvent(new AnimalMoveEvent(AnimalMoveEvent.REQUEST_RANDOM_EMPTY_COORDINATES_IN_BUILDING, this));
		}));
	}
}