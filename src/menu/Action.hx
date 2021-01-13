package menu;

class Action extends Item
{
	public var action:Void->Void;
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
	}
}