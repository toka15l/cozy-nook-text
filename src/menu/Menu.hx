package menu;
import openfl.display.Sprite;
import openfl.display.Bitmap;

class Menu extends Board
{	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
	}
	
	public function addMultipleItemSelect(items:Array<WorldItem>, tileX:Int, tileY:Int):Void {
		var menuSelectItems:Array<MenuSelectItem> = [];
		for (item in items) {
			var menuSelectItem:MenuSelectItem = new MenuSelectItem(item.spriteCharCode, item.color);
			menuSelectItem.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(menuSelectItem.spriteCharCode));
			menuSelectItems.push(menuSelectItem);
		}
		drawMenu(menuSelectItems, tileX, tileY);
	}
	
	private function drawMenu(items:Array<MenuSelectItem>, tileX:Int, tileY:Int):Void {
		drawBorderPiece(201, tileX - 1, tileY + 1); // top left
		drawBorderPiece(186, tileX - 1, tileY + 2); // middle left
		drawBorderPiece(200, tileX - 1, tileY + 3); // bottom left
		for (i in 0...items.length) {
			drawBorderPiece(i == 0 ? 207 : 205, tileX + i, tileY + 1); // arrow or top middle
			items[i].x = (tileX + i) * SpriteBitmapData.SPRITE_WIDTH;
			items[i].y = (tileY + 2) * SpriteBitmapData.SPRITE_HEIGHT;
			addChild(items[i]);
			drawBorderPiece(205, tileX + i, tileY + 3); // bottom middle
		}
		var rightX:Int = tileX + items.length;
		drawBorderPiece(187, rightX, tileY + 1); // top right
		drawBorderPiece(186, rightX, tileY + 2); // middle right
		drawBorderPiece(188, rightX, tileY + 3); // bottom right
	}
	
	private function drawBorderPiece(spriteCharCode:Int, tileX:Int, tileY:Int):Void {
		var borderPiece:Item = new MenuItem(spriteCharCode);
		borderPiece.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(borderPiece.spriteCharCode));
		borderPiece.x = tileX * SpriteBitmapData.SPRITE_WIDTH;
		borderPiece.y = tileY * SpriteBitmapData.SPRITE_HEIGHT;
		addChild(borderPiece);
	}
	
	public function addMultipleActions(actions:Array<Action>, spriteCharCode:Int, color:Int, tileX:Int, tileY:Int):Void {
		trace("multiple actions: " + tileX + ", " + tileY);
	}
	
	public function nextSelection():Void {
		//
	}
	
	public function previousSelection():Void {
		//
	}
	
	public function exitMenu():Void {
		//
	}
	
	public function executeSelectedAction():Void {
		//
	}
}