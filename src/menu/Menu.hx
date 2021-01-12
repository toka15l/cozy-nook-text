package menu;
import openfl.display.Sprite;
import openfl.display.Bitmap;

/*class Menu extends Sprite
{
	public var spriteBitmapData:SpriteBitmapData;
	public var active:Bool = false;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super();
		
		this.spriteBitmapData = spriteBitmapData;
	}
	
	public function addMultipleActions(actions:Array<Action>, spriteCharCode:Int, color:Int, tileX:Int, tileY:Int):Void {
		trace(tileX, tileY);
		if (active == false) {
			active = true;
			//item.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(item.spriteCharCode));
		}
		
		
	}
	
	public function navigate(x:Int, y:Int):Void {
		//
	}
	
	public function executeSelectedAction():Void {
		//
	}
	
	public function exitMenu():Void {
		//
	}
}*/


class Menu extends Board
{
	private static inline var DESELECTED_COLOR = 0x777777;
	private var allActions:Array<Action> = [];
	private var currentY:Int = 0;
	private var currentAction:Action = null;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
	}
	
	public function addMultipleItemSelect(items:Array<WorldItem>, tileX:Int, tileY:Int):Void {
		trace("multiple select: " + tileX + ", " + tileY);
		var currentX:Int = tileX;
		for (item in items) {
			var menuSelectItem:MenuSelectItem = new MenuSelectItem(item.spriteCharCode, item.color);
			menuSelectItem.setBitmapData(spriteBitmapData.getBitmapDataForCharCode(menuSelectItem.spriteCharCode));
			menuSelectItem.x = currentX * SpriteBitmapData.SPRITE_WIDTH;
			menuSelectItem.y = (tileY + 1) * SpriteBitmapData.SPRITE_HEIGHT;
			addChild(menuSelectItem);
			currentX++;
		}
	}
	
	public function addMultipleActions(actions:Array<Action>, spriteCharCode:Int, color:Int, tileX:Int, tileY:Int):Void {
		
		
		trace("multiple actions: " + tileX + ", " + tileY);
		
		
		
		/*addItemsToTile([new Item(207)], 6, 5);
		addItemsToTile([new Item(201)], 5, 5);
		addItemsToTile([new Item(187)], 7, 5);
		addItemsToTile([new Item(186)], 5, 6);
		addItemsToTile([new Item(186)], 7, 6);
		addItemsToTile([new Item(200)], 5, 7);
		addItemsToTile([new Item(188)], 7, 7);
		addItemsToTile([new Item(205)], 6, 7);*/
		
		
		
		/*trace(tileX + ", " + tileY);
		var test:Sprite = new Sprite();
		test.addChild(new Bitmap(spriteBitmapData.getBitmapDataForCharCode(219)));
		addChild(test);
		test.x = tileX * SpriteBitmapData.SPRITE_WIDTH;
		test.y = tileY * SpriteBitmapData.SPRITE_HEIGHT;*/
		
		
		
		
		
		
		
		// insert space between menu object sections
		/*if (currentY != 0) {
			currentY += 2;
		}
		var preselected:Bool = false;
		for (i in 0...actions.length) {
			if (actions[i].selected == true) {
				preselected = true;
			}
			addAction(actions[i], 0, currentY);
			currentY += 2;
			allActions.push(actions[i]);
		}
		if (preselected == false) {
			selectAction(allActions[0]);
		}*/
	}
	
	private function addAction(action:Action, x:Int, y:Int):Void {
		/*for (i in 0...action.string.length) {
			var letter:Item = new Item(action.string.charCodeAt(i), action.selected ? null : DESELECTED_COLOR);
			addItemToTile(letter, x + i, y);
			action.menuItems.push(letter);
		}*/
	}
	
	public function nextSelection():Void {
		/*for (i in 0...allActions.length) {
			if (allActions[i].selected == true) {
				selectAction(allActions[i], false);
				if (i + 1 >= allActions.length) {
					selectAction(allActions[0], true);
				} else {
					selectAction(allActions[i + 1], true);
				}
				break;
			}
		}*/
	}
	
	public function previousSelection():Void {
		/*for (i in 0...allActions.length) {
			if (allActions[i].selected == true) {
				selectAction(allActions[i], false);
				if (i - 1 < 0) {
					selectAction(allActions[allActions.length - 1], true);
				} else {
					selectAction(allActions[i - 1], true);
				}
				break;
			}
		}*/
	}
	
	private function selectAction(action:Action, select:Bool = true):Void {
		/*var startX:Int = -1;
		var startY:Int = -1;
		for (item in action.menuItems) {
			var tile:Tile = cast item.parent;
			if (startX == -1 || tile.tileX < startX) {
				startX = tile.tileX;
			}
			if (startY == -1 || tile.tileY < startY) {
				startY = tile.tileY;
			}
			tile.removeItem(item);
		}
		action.selected = select;
		action.menuItems = [];
		addAction(action, startX, startY);
		currentAction = action;*/
	}
	
	public function exitMenu():Void {
		/*for (action in allActions) {
			action.selected = false;
			action.menuItems = [];
		}
		emptyAllTiles();
		allActions = [];
		currentY = 0;*/
	}
	
	public function executeSelectedAction():Void {
		/*if (currentAction.action != null) {
			currentAction.action();
			exitMenu();
		}*/
	}
}