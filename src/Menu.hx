package;

class Menu extends Board
{
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
		
		// initialize sprite bitmap data
		this.spriteBitmapData = spriteBitmapData;
	}
	
	public function addMultipleMenuObjects(menuObjects:Array<MenuObject>, startX:Int, staryY:Int):Void {
		var currentY:Int = staryY;
		for (i in 0...menuObjects.length) {
			if (i == 0) {
				menuObjects[i].selected = true;
			}
			addMenuObject(menuObjects[i], startX, currentY);
			currentY += 2;
		}
	}
	
	private function addMenuObject(menuObject:MenuObject, x:Int, y:Int):Void {
		for (i in 0...menuObject.string.length) {
			var item:Item = new Item();
			if (menuObject.selected == false) {
				item.color = 0x777777;
			}
			item.spriteCharCode = menuObject.string.charCodeAt(i);
			addItemsToTile([item], x + i, y);
		}
	}
}