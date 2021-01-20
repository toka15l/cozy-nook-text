package menu;

class SelfAction extends Item
{
	public var selfActionFunction:Void->Void;
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
	}
}