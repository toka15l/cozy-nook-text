package;

class Menu extends Board
{	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
		
		// initialize sprite bitmap data
		this.spriteBitmapData = spriteBitmapData;
		
		var test:String = "Hello There!";
		for (i in 0...test.length) {
			var item:Item = new Item();
			item.spriteCharCode = test.charCodeAt(i);
			addItemsToTile([item], i, 0);
		}
	}	
}