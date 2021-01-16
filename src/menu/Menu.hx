package menu;
import MenuSelfActionItem;
import openfl.events.Event;

class Menu extends Board
{
	public var active:Bool = false;
	public var menuSelectItems:Array<MenuSelectItem> = [];
	public var menuActionItems:Array<MenuSelfActionItem> = [];
	public var menuTargetItems:Array<MenuTargetActionItem> = [];
	private var dropItem:WorldItem;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
	}
	
	public function displayItemSelect(items:Array<WorldItem>, tile:WorldTile):Void {
		menuSelectItems = [];
		for (item in items) {
			var menuSelectItem:MenuSelectItem = new MenuSelectItem(item);
			menuSelectItem.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(menuSelectItem.spriteCharCode));
			menuSelectItems.push(menuSelectItem);
		}
		drawMenu(cast menuSelectItems, tile);
	}
	
	public function displaySelfActionSelect(item:WorldItem):Void {
		var tile:WorldTile = cast item.parent;
		menuActionItems = [];
		for (selfAction in item.selfActions) {
			var menuActionItem:MenuSelfActionItem = new MenuSelfActionItem(selfAction);
			menuActionItem.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(menuActionItem.spriteCharCode));
			menuActionItems.push(menuActionItem);
		}
		drawMenu(cast menuActionItems, tile);
	}
	
	public function displayTargetActionSelect(dropItem:WorldItem):Void {
		this.dropItem = dropItem;
		var tile:WorldTile = cast dropItem.parent;
		var applicableTargetItems:Array<WorldItem> = [];
		for (targetItem in tile.items) {
			if (targetItem != dropItem && getApplicableTargetActions(dropItem, targetItem).length > 0) {
				applicableTargetItems.push(targetItem);
			}
		}
		displayItemSelect(applicableTargetItems, tile);
	}
	
	private function getApplicableTargetActions(dropItem:WorldItem, targetItem:WorldItem):Array<TargetAction> {
		var currentClass:Any = Type.getClass(dropItem);
		var containedClasses:Array<String> = [Type.getClassName(currentClass)];
		while (currentClass != WorldItem) {
			currentClass = Type.getSuperClass(currentClass);
			containedClasses.push(Type.getClassName(currentClass));
		}
		var applicableDropActions:Array<TargetAction> = [];
		for (dropAction in targetItem.targetActions) {
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
		menuTargetItems = [];
		for (targetAction in getApplicableTargetActions(dropItem, targetItem)) {
			var menuActionItem:MenuTargetActionItem = new MenuTargetActionItem(targetAction);
			menuActionItem.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(menuActionItem.spriteCharCode));
			menuTargetItems.push(menuActionItem);
		}
		drawMenu(cast menuTargetItems, tile);
	}
	
	private function drawMenu(items:Array<MenuInteractiveItem>, tile:WorldTile):Void {
		if (items.length > 0) {
			active = true;
			drawBorderPiece(201, tile.tileX - 1, tile.tileY + 1); // top left
			drawBorderPiece(186, tile.tileX - 1, tile.tileY + 2); // middle left
			drawBorderPiece(200, tile.tileX - 1, tile.tileY + 3); // bottom left
			for (i in 0...items.length) {
				drawBorderPiece(i == 0 ? 207 : 205, tile.tileX + i, tile.tileY + 1); // arrow or top middle
				items[i].select(i == 0);
				items[i].x = (tile.tileX + i) * SpriteBitmapData.SPRITE_WIDTH;
				items[i].y = (tile.tileY + 2) * SpriteBitmapData.SPRITE_HEIGHT;
				addChild(items[i]);
				drawBorderPiece(205, tile.tileX + i, tile.tileY + 3); // bottom middle
			}
			var rightX:Int = tile.tileX + items.length;
			drawBorderPiece(187, rightX, tile.tileY + 1); // top right
			drawBorderPiece(186, rightX, tile.tileY + 2); // middle right
			drawBorderPiece(188, rightX, tile.tileY + 3); // bottom right
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
		menuTargetItems = [];
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
					menuActionItem.selfAction.selfActionFunction();
					break;
				}
			}
		} else if (menuTargetItems.length > 0) {
			for (menuTargetItem in menuTargetItems) {
				if (menuTargetItem.selected == true) {
					menuTargetItem.targetAction.targetAction(dropItem);
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