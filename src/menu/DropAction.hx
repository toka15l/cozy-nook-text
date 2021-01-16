package menu;

class DropAction extends Item
{
	public var dropAction:WorldItem->Void;
	public var applicableClasses:Array<String>;
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
	}
}