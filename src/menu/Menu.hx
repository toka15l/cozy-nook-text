package menu;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.events.Event;

class Menu extends Board
{
	public var active:Bool = false;
	public var menuSelectItems:Array<MenuSelectItem> = [];
	public var menuActionItems:Array<MenuActionItem> = [];
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
	}
	
	public function addMultipleItemSelect(items:Array<WorldItem>, tileX:Int, tileY:Int):Void {
		menuSelectItems = [];
		for (item in items) {
			var menuSelectItem:MenuSelectItem = new MenuSelectItem(item);
			menuSelectItem.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(menuSelectItem.spriteCharCode));
			menuSelectItems.push(menuSelectItem);
		}
		drawMenu(cast menuSelectItems, tileX, tileY);
	}
	
	public function addMultipleActions(item:WorldItem, tileX:Int, tileY:Int):Void {
		menuActionItems = [];
		for (action in item.actions) {
			var menuActionItem:MenuActionItem = new MenuActionItem(action);
			menuActionItem.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(menuActionItem.spriteCharCode));
			menuActionItems.push(menuActionItem);
		}
		drawMenu(cast menuActionItems, tileX, tileY);
	}
	
	private function drawMenu(items:Array<MenuInteractiveItem>, tileX:Int, tileY:Int):Void {
		active = true;
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
	
	public function nextSelection():Void {
		navigate(menuSelectItems.length > 0 ? cast menuSelectItems : cast menuActionItems, 1);
	}
	
	public function previousSelection():Void {
		navigate(menuSelectItems.length > 0 ? cast menuSelectItems : cast menuActionItems, -1);
	}
	
	private function navigate(menuInteractiveItems:Array<MenuInteractiveItem>, direction:Int):Void {
		for (i in 0...menuInteractiveItems.length) {
			if (menuInteractiveItems[i].selected == true) {
				menuInteractiveItems[i].select(false);
				direction == 1 ? menuInteractiveItems[i < menuInteractiveItems.length - 1 ? i + 1 : 0].select(true) : menuInteractiveItems[i > 0 ? i - 1 : menuInteractiveItems.length - 1].select(true);
				break;
			}
		}
	}
	
	public function exitMenu():Void {
		active = false;
		removeChildren();
		menuSelectItems = [];
		menuActionItems = [];
		dispatchEvent(new MenuEvent(MenuEvent.EXIT_MENU));
	}
	
	public function executeSelectedAction():Void {
		for (menuSelectItem in menuSelectItems) {
			if (menuSelectItem.selected == true) {
				menuSelectItem.item.itemSelect();
				break;
			}
		}
		for (menuActionItem in menuActionItems) {
			if (menuActionItem.selected == true) {
				menuActionItem.action.action();
				break;
			}
		}
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