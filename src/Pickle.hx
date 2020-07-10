package;
import menu.MenuObject;

class Pickle extends Item
{	
	public function new() {
		spriteCharCode = 41;
		color = 0x98FB98;
		
		menuObjects = [];
		var eatPickle:MenuObject = new MenuObject();
		eatPickle.string = "Eat Pickle";
		menuObjects.push(eatPickle);
		
		super();
	}
}