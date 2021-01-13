package menu;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.events.Event;

class Menu extends Board
{
	public var active:Bool = false;
	public var menuSelectItems:Array<MenuSelectItem>;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
	}
	
	public function addMultipleItemSelect(items:Array<WorldItem>, tileX:Int, tileY:Int):Void {
		active = true;
		menuSelectItems = [];
		for (item in items) {
			var menuSelectItem:MenuSelectItem = new MenuSelectItem(item);
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
			items[i].select(i == 0);
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
		for (i in 0...menuSelectItems.length) {
			if (menuSelectItems[i].selected == true) {
				menuSelectItems[i].select(false);
				menuSelectItems[i < menuSelectItems.length - 1 ? i + 1 : 0].select(true);
				break;
			}
		}
	}
	
	public function previousSelection():Void {
		for (i in 0...menuSelectItems.length) {
			if (menuSelectItems[i].selected == true) {
				menuSelectItems[i].select(false);
				menuSelectItems[i > 0 ? i - 1 : menuSelectItems.length - 1].select(true);
				break;
			}
		}
	}
	
	public function exitMenu():Void {
		active = false;
		removeChildren();
		dispatchEvent(new MenuEvent(MenuEvent.EXIT_MENU));
	}
	
	public function executeSelectedAction():Void {
		for (menuSelectItem in menuSelectItems) {
			if (menuSelectItem.selected == true) {
				menuSelectItem.item.itemSelect();
				break;
			}
		}
		menuSelectItems = [];
		exitMenu();
	}
}

class MenuEvent extends Event {
	public static inline var EXIT_MENU = "exitMenu";
	
	public function new(type:String)
    {
        super(type, true, false);
    }
}