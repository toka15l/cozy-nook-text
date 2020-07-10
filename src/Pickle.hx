package;
import menu.Action;

class Pickle extends Item
{	
	public function new() {
		spriteCharCode = 41;
		color = 0x98FB98;
		
		actions = [];
		var move:Action = new Action();
		move.string = "Move";
		actions.push(move);
		
		var eatPickle:Action = new Action();
		eatPickle.string = "Eat Pickle";
		actions.push(eatPickle);
		
		super();
	}
}