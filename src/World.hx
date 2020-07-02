package;
import openfl.display.MovieClip;

class World extends MovieClip
{
	private static var ZOOM_FACTOR:Int = 1;
	private static var INITIAL_SCALE:Int = 3;
	private var bitmaps:Bitmaps = null;
	
	public function new() {		
		super();
		
		scaleX = scaleY = INITIAL_SCALE;
		
		bitmaps = new Bitmaps();
		
		addChild(bitmaps.DWARF);
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