package;

class World extends Board
{
	private var building:Building = null;
	private var selectionStartTile:Tile = null;
	
	public function new(spriteBitmapData:SpriteBitmapData) {
		super(spriteBitmapData);
		
		// test dwarf
		addItemsToTile([new Dwarf()], 1, 2);
		
		// test cursor
		cursor = new Plus();
		addItemsToTile([cursor], 5, 5);
		
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
	}
	
	//================================================================================
    // MULTIPLE TILE OBJECTS
    //================================================================================	
	public function multipleTileSelect():Void {
		if (selectionStartTile == null) {
			selectionStartTile = cast cursor.parent;
			building = new Building(selectionStartTile.tileX, selectionStartTile.tileY);
			for (item in building.items) {
				addItemsToTile([item[0]], item[1], item[2]);
			}
		} else {
			selectionStartTile = null;
		}
	}
	
	//================================================================================
    // ITEM MOVING
    //================================================================================	
	public override function move(distanceX:Int, distanceY:Int):Void {
		super.move(distanceX, distanceY);
		if (selectionStartTile != null) {
			var tile:Tile = cast cursor.parent;
			for (item in building.items) {
				var itemOject:Item = cast item[0];
				var itemTile:Tile = cast itemOject.parent;
				removeItemsFromTile([itemOject], itemTile);
			}
			building.changeEnd(tile.tileX, tile.tileY);
			for (item in building.items) {
				addItemsToTile([item[0]], item[1], item[2]);
			}
		}
	}
}