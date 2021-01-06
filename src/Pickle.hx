package;
import menu.Action;

class Pickle extends Item
{	
	public function new() {
		spriteCharCode = 41;
		color = 0x98FB98;
		
		super();
		
		var actionEatPickle:Action = new Action();
		actionEatPickle.string = "Eat Pickle";
		actions.push(actionEatPickle);
	}
}