package;
import openfl.display.Sprite;

class Board extends Sprite
{
	private static inline var ZOOM_FACTOR:Int = 1;
	private static inline var INITIAL_SCALE:Int = 3;
	public var spriteBitmapData:SpriteBitmapData;
	private var cursor:Sprite = null;
	private var carriedItems:Array<WorldItem> = [];
	private var cursorX:Int = 0;
	private var cursorY:Int = 0;
	
	public function new(spriteBitmapData:SpriteBitmapData, initialScale:Int = null) {
		super();
		
		// set initial scale (zoom)
		scaleX = scaleY = initialScale != null ? initialScale : INITIAL_SCALE;
		
		// initialize sprite bitmap data
		this.spriteBitmapData = spriteBitmapData;
	}
	
	public function isEmpty():Bool {
		if (numChildren == 0) {
			return true;
		}
		return false;
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