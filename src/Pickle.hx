package;
import menu.SelfAction;

class Pickle extends WorldItem
{	
	public function new() {
		super(41, 0x98FB98);
		
		var actionEatPickle:SelfAction = new SelfAction(69, 0x00FF00);
		selfActions.push(actionEatPickle);
	}
}