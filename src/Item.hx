package;
import openfl.display.Bitmap;
import openfl.display.MovieClip;

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
}