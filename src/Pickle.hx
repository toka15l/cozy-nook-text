package;
import menu.Action;

class Pickle extends WorldItem
{	
	public function new() {
		super(41, 0x98FB98);
		
		var actionEatPickle:Action = new Action(69, 0x00FF00);
		actions.push(actionEatPickle);
	}
}