package;
import menu.Action;

class Pickle extends WorldItem
{	
	public function new() {
		super(41, 0x98FB98);
		
		var actionEatPickle:Action = new Action();
		actionEatPickle.string = "Eat Pickle";
		actions.push(actionEatPickle);
	}
}