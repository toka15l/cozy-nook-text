package;
import openfl.display.Sprite;

class Board extends Sprite
{
	private static inline var ZOOM_FACTOR:Int = 1;
	private static inline var INITIAL_SCALE:Int = 3;
	public var spriteBitmapData:SpriteBitmapData;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super();
		
		// set initial scale (zoom)
		scaleX = scaleY = INITIAL_SCALE;
		
		// initialize sprite bitmap data
		this.spriteBitmapData = spriteBitmapData;
	}
	
	//================================================================================
    // ZOOM
    //================================================================================
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