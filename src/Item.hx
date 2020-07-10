package;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import menu.Menu;
import menu.Action;

class Item extends Sprite
{
	public var spriteCharCode:Int;
	public var color:Int;
	public var actions:Array<Action>;

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
		dispatchEvent(new ItemMoveEvent(ItemMoveEvent.MOVE, distanceX, distanceY));
	}
	
	public function itemSelect():Void {
		if (actions != null) {
			dispatchEvent(new ItemSelectEvent(ItemSelectEvent.REQUEST_ACTIONS, actions));
		}
	}
}

class ItemMoveEvent extends Event {
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

class ItemSelectEvent extends Event {
	public static inline var REQUEST_ACTIONS = "requestActions";
	public var actions:Array<Action> = null;
	
	public function new(type:String, actions:Array<Action>)
    {
		this.actions = actions;
        super(type, true, false);
    }
}