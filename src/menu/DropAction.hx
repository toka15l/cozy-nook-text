package menu;

class DropAction extends Action
{
	public var applicableClasses:Array<String>;
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
	}
}