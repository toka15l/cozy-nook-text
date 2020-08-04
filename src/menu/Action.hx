package menu;

class Action
{
	public var string:String;
	public var selected:Bool = false;
	public var menuItems:Array<Item> = [];
	public var action:Void->Void;
	
	public function new() {
		//
	}
}