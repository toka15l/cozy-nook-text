package menu;

class TargetAction extends Item
{
	public var targetAction:WorldItem->Void;
	public var applicableClasses:Array<String>;
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
	}
}