package;
import openfl.display.Bitmap;
import openfl.display.MovieClip;
import openfl.geom.Point;

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
		addItem(bitmaps.PLUS, 5, 5);
	}
	
	private function addItem(bitmap:Bitmap, x:Int, y:Int):Void {
		while (itemMatrix.length < x + 1) {
			itemMatrix.push([]);
		}
		while (itemMatrix[x].length < y) {
			itemMatrix[x].push(null);
		}
		var item:Item = new Item();
		item.bitmap = bitmap;
		item.needsRedraw = true;
		itemMatrix[x][y] = item;		
		redraw();
	}
	
	private function redraw():Void {
		for (x in 0...itemMatrix.length) {
			for (y in 0...itemMatrix[x].length) {
				var item:Item = itemMatrix[x][y];
				if (item != null && item.needsRedraw == true) {
					var removeArray:Array<Bitmap> = cast getObjectsUnderPoint(new Point((x * bitmaps.SPRITE_WIDTH) + (bitmaps.SPRITE_WIDTH / 2), (y * bitmaps.SPRITE_HEIGHT) + (bitmaps.SPRITE_HEIGHT / 2)));
					for (remove in removeArray) {
						removeChild(remove);
					}
					if (item.bitmap != null) {
						item.bitmap.x = x * bitmaps.SPRITE_WIDTH;
						item.bitmap.y = y * bitmaps.SPRITE_HEIGHT;
						addChild(item.bitmap);
						item.needsRedraw = false;
					}
				}
			}
		}
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