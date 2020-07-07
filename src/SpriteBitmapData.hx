package;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import sys.FileSystem;
import openfl.Assets;

class SpriteBitmapData 
{
	private static inline var SPRITE_FILE:String = "curses_800x600.png";
	public static inline var SPRITE_WIDTH:Int = 10;
	public static inline var SPRITE_HEIGHT:Int = 12;
	private var spriteBitmapData:Array<BitmapData> = [];

	public function new() {
		var path:String = "assets/img/" + SPRITE_FILE;
		if (FileSystem.exists(path)) {
			var spriteFile:Bitmap = new Bitmap(Assets.getBitmapData(path));
			var bitmapDataSource:BitmapData = spriteFile.bitmapData;			
			for (y in 0...Std.int(spriteFile.height / SPRITE_HEIGHT)) {
				for (x in 0...Std.int(spriteFile.width / SPRITE_WIDTH)) {
					var bitmapDataDestination:BitmapData = new BitmapData(SPRITE_WIDTH, SPRITE_HEIGHT);
					var rect:Rectangle = new Rectangle(x * SPRITE_WIDTH, y * SPRITE_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT);
					bitmapDataDestination.copyPixels(bitmapDataSource, rect, new Point(0, 0));
					spriteBitmapData.push(bitmapDataDestination);
				}
			}
		}	
	}
	
	public function getBitmapDataForCharCode(charCode:Int):BitmapData {
		return spriteBitmapData[charCode];
	}
}