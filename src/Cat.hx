package;
import WorldItem.ItemTickEvent;

class Cat extends WorldItem
{
	public function new() {
		super(99);
	}
	
	public override function registerTickActions():Void {
		dispatchEvent(new ItemTickEvent(ItemTickEvent.REGISTER, 2, function () {
			var tile:WorldTile = cast parent;
			var world:World = cast tile.parent;
			var neighbors:Array<Array<WorldTile>> = world.getNeighbors(tile);
			if (neighbors[2][1] == null) {
				move(1, 0);
			}
		}));
	}
}