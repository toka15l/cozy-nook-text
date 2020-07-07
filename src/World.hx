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
		
		// test building
		var test:Building = new Building(2, 2, 5, 5);
		for (item in test.items) {
			addItemsToTile([item[0]], item[1], item[2]);
		}			
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