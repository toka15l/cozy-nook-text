package;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;

class Item extends MovieClip
{
	public var spriteCharCode:Int;
	public var color:Int;

	public function new() {
		super();
	}
	
	public function setBitmapData(bitmapData:BitmapData) {
		if (color != null) {
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			var colorBitmapData:BitmapData = bitmapData.clone();
			colorBitmapData.colorTransform(new Rectangle(0, 0, SpriteBitmapData.SPRITE_WIDTH, SpriteBitmapData.SPRITE_HEIGHT), colorTransform);
			addChild(new Bitmap(colorBitmapData));
		} else {
			addChild(new Bitmap(bitmapData));
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