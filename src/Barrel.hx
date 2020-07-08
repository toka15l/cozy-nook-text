package;

class Barrel extends Container
{
	public function new() {
		spriteCharCode = 233;
		color = 0xA0522D;
		
		menuObjects = [];
		var pickupItem:MenuObject = new MenuObject();
		pickupItem.string = "Pick up pickle";
		menuObjects.push(pickupItem);
		
		var dropItem:MenuObject = new MenuObject();
		dropItem.string = "Drop pickle";
		menuObjects.push(dropItem);
		
		super();
	}
}