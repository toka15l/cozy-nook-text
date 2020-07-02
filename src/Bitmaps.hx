package;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import sys.FileSystem;
import openfl.Assets;

class Bitmaps 
{
	private static var SPRITE_FILE:String = "curses_800x600.png";
	public var SPRITE_WIDTH:Int = 10;
	public var SPRITE_HEIGHT:Int = 12;
	public var DWARF:Bitmap = null;
	public var PLUS:Bitmap = null;

	public function new() {
		var path:String = "assets/img/" + SPRITE_FILE;
		if (FileSystem.exists(path)) {
			var spriteFile:Bitmap = new Bitmap(Assets.getBitmapData(path));
			var bitmapDataSource:BitmapData = spriteFile.bitmapData;
			for (x in 0...Std.int(spriteFile.width / SPRITE_WIDTH)) {
				for (y in 0...Std.int(spriteFile.height / SPRITE_HEIGHT)) {
					var bitmapDataDestination:BitmapData = new BitmapData(SPRITE_WIDTH, SPRITE_HEIGHT);
					var rect:Rectangle = new Rectangle(x * SPRITE_WIDTH, y * SPRITE_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT);
					bitmapDataDestination.copyPixels(bitmapDataSource, rect, new Point(0, 0));
					if (x == 2 && y == 0) {
						DWARF = new Bitmap(bitmapDataDestination);
					}
					if (x == 11 && y == 2) {
						PLUS = new Bitmap(bitmapDataDestination);
					}
				}
			}
		}	
	}	
}