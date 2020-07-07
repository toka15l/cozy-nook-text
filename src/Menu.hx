package;

class Menu extends Board
{	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
		
		// initialize sprite bitmap data
		this.spriteBitmapData = spriteBitmapData;
		
		var test:String = "P";
		trace(test.charCodeAt(0));
	}	
}