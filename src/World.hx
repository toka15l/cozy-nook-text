package;
import openfl.display.MovieClip;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import sys.FileSystem;
import openfl.Assets;

class World extends MovieClip
{
	private static var SPRITE_FILE:String = "curses_800x600.png";
	public static var SPRITE_WIDTH:Int = 10;
	public static var SPRITE_HEIGHT:Int = 12;
	public var DWARF:Bitmap = null;
	private static var ZOOM_FACTOR:Int = 1;
	private static var INITIAL_SCALE:Int = 3;
	
	public function new() {
		var path:String = "assets/img/" + SPRITE_FILE;
		if (FileSystem.exists(path)) {
			var spriteFile:Bitmap = new Bitmap(Assets.getBitmapData(path));
			var bitmapDataSource:BitmapData = spriteFile.bitmapData;
			var bitmapDataDestination:BitmapData = new BitmapData(SPRITE_WIDTH, SPRITE_HEIGHT);
			var rect:Rectangle = new Rectangle(20, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
			bitmapDataDestination.copyPixels(bitmapDataSource, rect, new Point(0, 0));
			DWARF = new Bitmap(bitmapDataDestination);
		}	
		
		super();
		
		scaleX = scaleY = INITIAL_SCALE;
		
		addChild(DWARF);
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