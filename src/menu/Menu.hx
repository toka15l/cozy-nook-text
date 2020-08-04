package menu;

class Menu extends Board
{
	private static inline var DESELECTED_COLOR = 0x777777;
	private var allActions:Array<Action> = [];
	private var currentY:Int = 0;
	private var currentAction:Action = null;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		this.spriteBitmapData = spriteBitmapData;
		super(spriteBitmapData, 1);
	}
	
	public function addMultipleActions(actions:Array<Action>, startX:Int):Void {
		// insert space between menu object sections
		if (currentY != 0) {
			currentY += 2;
		}		
		var preselected:Bool = false;
		for (i in 0...actions.length) {
			if (actions[i].selected == true) {
				preselected = true;
			}
			addAction(actions[i], startX, currentY);
			currentY += 2;
			allActions.push(actions[i]);
		}
		if (preselected == false) {
			selectAction(allActions[0]);
		}
	}
	
	private function addAction(action:Action, x:Int, y:Int):Void {
		for (i in 0...action.string.length) {
			var item:Item = new Item();
			if (action.selected == false) {
				item.color = DESELECTED_COLOR;
			}
			item.spriteCharCode = action.string.charCodeAt(i);
			addItemsToTile([item], x + i, y);
			action.menuItems.push(item);
		}
	}
	
	public function nextSelection():Void {
		for (i in 0...allActions.length) {
			if (allActions[i].selected == true) {
				selectAction(allActions[i], false);
				if (i + 1 >= allActions.length) {
					selectAction(allActions[0], true);
				} else {
					selectAction(allActions[i + 1], true);
				}
				break;
			}
		}
	}
	
	public function previousSelection():Void {
		for (i in 0...allActions.length) {
			if (allActions[i].selected == true) {
				selectAction(allActions[i], false);
				if (i - 1 < 0) {
					selectAction(allActions[allActions.length - 1], true);
				} else {
					selectAction(allActions[i - 1], true);
				}
				break;
			}
		}
	}
	
	private function selectAction(action:Action, select:Bool = true):Void {
		var startX:Int = -1;
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
		currentAction = action;
	}
	
	public function exitMenu():Void {
		for (action in allActions) {
			action.selected = false;
			action.menuItems = [];
		}
		emptyAllTiles();
		allActions = [];
		currentY = 0;
	}
	
	public function executeSelectedAction():Void {
		if (currentAction.action != null) {
			currentAction.action();
			exitMenu();
		}
	}
}