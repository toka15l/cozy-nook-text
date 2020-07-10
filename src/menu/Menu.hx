package menu;

class Menu extends Board
{
	private static inline var DESELECTED_COLOR = 0x777777;
	private var allMenuObjects:Array<MenuObject> = [];
	private var currentY:Int = 0;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		this.spriteBitmapData = spriteBitmapData;
		super(spriteBitmapData, 1);
	}
	
	public function addMultipleMenuObjects(menuObjects:Array<MenuObject>, startX:Int):Void {
		var preselected:Bool = false;
		for (i in 0...menuObjects.length) {
			if (menuObjects[i].selected == true) {
				preselected = true;
			}
			addMenuObject(menuObjects[i], startX, currentY);
			currentY += 2;
			allMenuObjects.push(menuObjects[i]);
		}
		if (preselected == false) {
			selectMenuObject(allMenuObjects[0]);
		}
	}
	
	private function addMenuObject(menuObject:MenuObject, x:Int, y:Int):Void {
		for (i in 0...menuObject.string.length) {
			var item:Item = new Item();
			if (menuObject.selected == false) {
				item.color = DESELECTED_COLOR;
			}
			item.spriteCharCode = menuObject.string.charCodeAt(i);
			addItemsToTile([item], x + i, y);
			menuObject.items.push(item);
		}
	}
	
	public function nextSelection():Void {
		for (i in 0...allMenuObjects.length) {
			if (allMenuObjects[i].selected == true) {
				selectMenuObject(allMenuObjects[i], false);
				if (i + 1 >= allMenuObjects.length) {
					selectMenuObject(allMenuObjects[0], true);
				} else {
					selectMenuObject(allMenuObjects[i + 1], true);
				}
				break;
			}
		}
	}
	
	public function previousSelection():Void {
		for (i in 0...allMenuObjects.length) {
			if (allMenuObjects[i].selected == true) {
				selectMenuObject(allMenuObjects[i], false);
				if (i - 1 < 0) {
					selectMenuObject(allMenuObjects[allMenuObjects.length - 1], true);
				} else {
					selectMenuObject(allMenuObjects[i - 1], true);
				}
				break;
			}
		}
	}
	
	private function selectMenuObject(menuObject:MenuObject, select:Bool = true):Void {
		var startX:Int = -1;
		var startY:Int = -1;
		for (item in menuObject.items) {
			var tile:Tile = cast item.parent;
			if (startX == -1 || tile.tileX < startX) {
				startX = tile.tileX;
			}
			if (startY == -1 || tile.tileY < startY) {
				startY = tile.tileY;
			}
			tile.removeItem(item);
		}
		menuObject.selected = select;
		menuObject.items = [];
		addMenuObject(menuObject, startX, startY);
	}
	
	public function exitWithoutSelection():Void {
		for (menuObject in allMenuObjects) {
			menuObject.selected = false;
			menuObject.items = [];
		}
		emptyAllTiles();
		allMenuObjects = [];
		currentY = 0;
	}
}