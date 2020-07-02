package;
import openfl.display.Bitmap;
import openfl.display.MovieClip;

class World extends MovieClip
{
	private static var ZOOM_FACTOR:Int = 1;
	private static var INITIAL_SCALE:Int = 3;
	private var bitmaps:Bitmaps = null;
	private var itemMatrix:Array<Array<Item>> = [];
	
	public function new() {		
		super();
		
		scaleX = scaleY = INITIAL_SCALE;
		
		bitmaps = new Bitmaps();
		
		addItem(bitmaps.DWARF, 2, 2);
	}
	
	private function addItem(bitmap:Bitmap, x:Int, y:Int):Void {
		bitmap.x = x * bitmaps.SPRITE_WIDTH;
		bitmap.y = y * bitmaps.SPRITE_HEIGHT;
		addChild(bitmap);
	}
	
	public function zoomIn():Void {
		changeZoom(ZOOM_FACTOR);
	}
	
	public function zoomOut():Void {
		changeZoom(ZOOM_FACTOR * -1);
	}
	
	private function changeZoom(change:Int):Void {
		if (scaleX + change <= 0) {
			return;
		}
		scaleX += change;
		scaleY += change;
	}
}