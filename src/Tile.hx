package;
import openfl.display.MovieClip;

class Tile extends MovieClip 
{
	public var tileX:Int = null;
	public var tileY:Int = null;

	public function new() {
		super();
	}
	
	public function addItem(item:Item):Void {
		addChild(item);
	}
}