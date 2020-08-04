package;
import menu.Action;

class Pickle extends Item
{	
	public function new() {
		spriteCharCode = 41;
		color = 0x98FB98;
		
		actions = [];
		var actionPickUp:Action = new Action();
		actionPickUp.string = "Pick Up";
		actionPickUp.action = pickUp;
		actions.push(actionPickUp);
		
		var actionEatPickle:Action = new Action();
		actionEatPickle.string = "Eat Pickle";
		actions.push(actionEatPickle);
		
		super();
	}
}