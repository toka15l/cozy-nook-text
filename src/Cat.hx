package;
import WorldItem.ItemTickEvent;

class Cat extends WorldItem
{
	public function new() {
		super(99);
	}
	
	public override function registerTickActions():Void {
		dispatchEvent(new ItemTickEvent(ItemTickEvent.REGISTER, 8, function () {
			trace("meow");
		}));
	}
}