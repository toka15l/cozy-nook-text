package menu;
import MenuActionItem;
import openfl.events.Event;

class Menu extends Board
{
	public var active:Bool = false;
	public var menuSelectItems:Array<MenuSelectItem> = [];
	public var menuActionItems:Array<MenuActionItem> = [];
	public var menuDropItems:Array<MenuDropActionItem> = [];
	private var dropItem:WorldItem;
	
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
	
	public function addItemDrops(dropItem:WorldItem):Void {
		this.dropItem = dropItem;
		var tile:WorldTile = cast dropItem.parent;
		var applicableDropItems:Array<WorldItem> = [];
		for (targetItem in tile.items) {
			if (targetItem != dropItem && getApplicableDropActions(dropItem, targetItem).length > 0) {
				applicableDropItems.push(targetItem);
			}
		}
		addMultipleItemSelect(applicableDropItems, tile.tileX, tile.tileY);
	}
	
	private function getApplicableDropActions(dropItem:WorldItem, targetItem:WorldItem):Array<DropAction> {
		var currentClass:Any = Type.getClass(dropItem);
		var containedClasses:Array<String> = [Type.getClassName(currentClass)];
		while (currentClass != WorldItem) {
			currentClass = Type.getSuperClass(currentClass);
			containedClasses.push(Type.getClassName(currentClass));
		}
		var applicableDropActions:Array<DropAction> = [];
		for (dropAction in targetItem.dropActions) {
			for (applicableClass in dropAction.applicableClasses) {
				for (containedClass in containedClasses) {
					if (containedClass == applicableClass) {
						applicableDropActions.push(dropAction);
						break; // TODO: break twice for efficiency
					}
				}
			}
		}
		return applicableDropActions;
	}
	
	private function addMultipleDropActions(targetItem:WorldItem):Void {
		var tile:WorldTile = cast targetItem.parent;
		menuDropItems = [];
		for (dropAction in getApplicableDropActions(dropItem, targetItem)) {
			var menuActionItem:MenuDropActionItem = new MenuDropActionItem(dropAction);
			menuActionItem.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(menuActionItem.spriteCharCode));
			menuDropItems.push(menuActionItem);
		}
		drawMenu(cast menuDropItems, tile.tileX, tile.tileY);
	}
	
	private function drawMenu(items:Array<MenuInteractiveItem>, tileX:Int, tileY:Int):Void {
		if (items.length > 0) {
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
	
	private function clearMenu():Void {
		removeChildren();
		menuSelectItems = [];
		menuActionItems = [];
		menuDropItems = [];
	}
	
	public function exitMenu():Void {
		clearMenu();
		active = false;
		dropItem = null;
		dispatchEvent(new MenuEvent(MenuEvent.EXIT_MENU));
	}
	
	public function executeSelected():Void {
		if (menuSelectItems.length > 0) {
			for (menuSelectItem in menuSelectItems) {
				if (menuSelectItem.selected == true) {
					clearMenu();
					if (dropItem != null) {
						addMultipleDropActions(menuSelectItem.item);
					} else {
						menuSelectItem.item.itemSelect();
					}
					break;
				}
			}
		} else if (menuActionItems.length > 0) {
			for (menuActionItem in menuActionItems) {
				if (menuActionItem.selected == true) {
					exitMenu();
					menuActionItem.action.action();
					break;
				}
			}
		} else if (menuDropItems.length > 0) {
			for (menuDropItem in menuDropItems) {
				if (menuDropItem.selected == true) {
					menuDropItem.dropAction.dropAction(dropItem);
					exitMenu();
					break;
				}
			}
		}
	}
}

class MenuEvent extends Event {
	public static inline var EXIT_MENU = "exitMenu";
	
	public function new(type:String)
    {
        super(type, true, false);
    }
}