package;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;

class Item extends Sprite
{
	public var spriteCharCode:Int;
	public var color:Int;

	public function new(spriteCharCode:Int, color:Int = null) {
		super();
		
		this.spriteCharCode = spriteCharCode;
		this.color = color;
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
}