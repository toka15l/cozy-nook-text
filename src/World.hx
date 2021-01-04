package;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class World extends Board
{
	private var building:Building = null;
	private var multipleSelect:Bool = false;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
		
		// test dwarf
		addItemsToTile([new Dwarf()], 1, 2);
		
		// cursor
		cursor = new Sprite();
		cursor.addChild(new Bitmap(spriteBitmapData.getBitmapDataForCharCode(219)));
		addChild(cursor);
		
		// test existing building
		var existingBuilding:Building = new Building(2, 2, 5, 5);
		for (item in existingBuilding.items) {
			addItemsToTile([item[0]], item[1], item[2]);
		}
		
		// test container object
		var containerObject:ContainerObject = new ContainerObject();
		containerObject.itemClass = Dwarf;
		containerObject.name = "Winston";
		containerObject.count = 2;
		var winston:Item = Type.createInstance(containerObject.itemClass, []);
		addItemsToTile([winston], 3, 3);
		
		// test barrel
		var testBarrel:Barrel = new Barrel();
		var pickles:ContainerObject = new ContainerObject();
		pickles.itemClass = Pickle;
		pickles.name = "Pickles";
		pickles.count = 34;
		testBarrel.addItem(pickles);
		addItemsToTile([testBarrel], 4, 4);
		
		// test pickle
		addItemsToTile([new Pickle()], 6, 4);
		
		// test butcher block
		addItemsToTile([new ButcherBlock()], 4, 3);
	}
	
	//================================================================================
    // MULTIPLE TILE OBJECTS
    //================================================================================	
	public function multipleTileSelect():Void {
		if (multipleSelect == false) {
			multipleSelect = true;
			building = new Building(cursorX, cursorY);
			for (item in building.items) {
				addItemsToTile([item[0]], item[1], item[2]);
			}
		} else {
			multipleSelect = false;
		}
	}
	
	//================================================================================
    // ITEM MOVING
    //================================================================================	
	public override function move(distanceX:Int, distanceY:Int):Void {
		super.move(distanceX, distanceY);
		cursor.x = cursorX * SpriteBitmapData.SPRITE_WIDTH;
		cursor.y = cursorY * SpriteBitmapData.SPRITE_HEIGHT;
		if (multipleSelect == true) {
			for (item in building.items) {
				var itemOject:Item = cast item[0];
				var itemTile:Tile = cast itemOject.parent;
				removeItemsFromTile([itemOject], itemTile);
			}
			building.changeEnd(cursorX, cursorY);
			for (item in building.items) {
				addItemsToTile([item[0]], item[1], item[2]);
			}
		}
	}
}