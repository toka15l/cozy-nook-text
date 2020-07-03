package;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import sys.FileSystem;
import openfl.Assets;

class Bitmaps 
{
	private static inline var SPRITE_FILE:String = "curses_800x600.png";
	public static inline var SPRITE_WIDTH:Int = 10;
	public static inline var SPRITE_HEIGHT:Int = 12;
	private var bitmaps:Array<Array<Bitmap>> = [];

	public function new() {
		var path:String = "assets/img/" + SPRITE_FILE;
		if (FileSystem.exists(path)) {
			var spriteFile:Bitmap = new Bitmap(Assets.getBitmapData(path));
			var bitmapDataSource:BitmapData = spriteFile.bitmapData;
				for (x in 0...Std.int(spriteFile.width / SPRITE_WIDTH)) {
				bitmaps.push([]);
				for (y in 0...Std.int(spriteFile.height / SPRITE_HEIGHT)) {
					var bitmapDataDestination:BitmapData = new BitmapData(SPRITE_WIDTH, SPRITE_HEIGHT);
					var rect:Rectangle = new Rectangle(x * SPRITE_WIDTH, y * SPRITE_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT);
					bitmapDataDestination.copyPixels(bitmapDataSource, rect, new Point(0, 0));
					bitmaps[x].push(new Bitmap(bitmapDataDestination));
				}
			}
		}	
	}
	
	public function getBitmapForCoordinates(x:Int, y:Int):Bitmap {
		return bitmaps[x][y];
	}
}