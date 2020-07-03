package;
import openfl.display.Bitmap;
import openfl.display.MovieClip;
import openfl.events.Event;

class Item extends MovieClip
{
	public var spriteX:Int;
	public var spriteY:Int;

	public function new() {
		super();
	}
	
	public function addBitmap(bitmap:Bitmap) {
		if (bitmap != null) {
			addChild(bitmap);
		}
	}
	
	public function move(distanceX:Int, distanceY:Int):Void {
		dispatchEvent(new ItemEvent(ItemEvent.MOVE, distanceX, distanceY));
	}
}

class ItemEvent extends Event {
	public static inline var MOVE = "move";
	public var distanceX:Int;
	public var distanceY:Int;
	
	public function new(type:String, distanceX:Int, distanceY:Int)
    {
		this.distanceX = distanceX;
		this.distanceY = distanceY;
        super(type, true, false);
    }
}