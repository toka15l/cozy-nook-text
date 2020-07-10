package;
import menu.Action;

class Barrel extends Container
{
	public function new() {
		spriteCharCode = 233;
		color = 0xA0522D;
		
		actions = [];
		var pickupItem:Action = new Action();
		pickupItem.string = "Pick up pickle";
		actions.push(pickupItem);
		
		var dropItem:Action = new Action();
		dropItem.string = "Drop pickle";
		actions.push(dropItem);
		
		var petWinston:Action = new Action();
		petWinston.string = "Pet Winston";
		actions.push(petWinston);
		
		super();
	}
}