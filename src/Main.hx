package;

import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.StageDisplayState;
import openfl.events.KeyboardEvent;
import openfl.system.System;
import openfl.ui.Mouse;
import menu.Menu;
import WorldTile.TileEvent;
import WorldItem.ItemSelectEvent;

class Main extends Sprite 
{
	private static inline var SHIFT_MOVE_MULTIPLIER:Int = 10;
	private static inline var MODE_SINGLE_TILE_SELECT:String = "modeSingleTileSelect";
	private static inline var MODE_BUILD:String = "modeBuild";
	private var spriteBitmapData:SpriteBitmapData = null;
	private var world:World = null;
	private var menu:Menu = null;
	private var currentMode:String = MODE_SINGLE_TILE_SELECT;

	public function new() {
		super();
		
		// hide mouse
		Mouse.hide();
		
		// event listeners
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		addEventListener(TileEvent.MULTIPLE_ITEM_SELECT, multipleItemSelect);
		addEventListener(ItemSelectEvent.REQUEST_ACTIONS, requestActions);
		
		// load sprite bitmap data
		spriteBitmapData = new SpriteBitmapData();
		
		// world
		world = new World(spriteBitmapData);
		addChild(world);
		
		// menu
		menu = new Menu(spriteBitmapData);
		addChild(menu);
	}

	private function keyUp(e:KeyboardEvent):Void {
		switch (e.keyCode) {
			case 13: // enter
				menu.active == true ? menu.executeSelectedAction() : executeMode();
			case 27: // esc
				if (menu.active == true) {
					menu.exitMenu();
				} else {
					stage.displayState == StageDisplayState.FULL_SCREEN ? exitFullscreen() : exit();
				}
			case 37: // left
				if (menu.active == true) {
					menu.previousSelection();
				} else {
					world.move((e.shiftKey == true ? SHIFT_MOVE_MULTIPLIER : 1) * -1, 0);
				}
			case 38: // up
				if (menu.active == true) {
					menu.previousSelection();
				} else {
					world.move(0, (e.shiftKey == true ? SHIFT_MOVE_MULTIPLIER : 1) * -1);
				}
			case 40: // down
				if (menu.active == true) {
					menu.nextSelection();
				} else {
					world.move(0, (e.shiftKey == true ? SHIFT_MOVE_MULTIPLIER : 1));
				}				
			case 39: // right
				if (menu.active == true) {
					menu.nextSelection();
				} else {
					world.move((e.shiftKey == true ? SHIFT_MOVE_MULTIPLIER : 1), 0);
				}
			case 66: // b
				currentMode = MODE_BUILD;
			case 70: // f
				enterFullscreen();
			case 75: // k
				currentMode = MODE_SINGLE_TILE_SELECT;
			case 187: // +=
				if (e.shiftKey == true) {
					world.zoomIn();
					menu.zoomIn();
				}
			case 189: // -_
				if (e.shiftKey == true) {
					world.zoomOut();
					menu.zoomOut();
				}
			default:
		}
	}
	
	private function executeMode():Void {
		switch (currentMode) {
			case MODE_SINGLE_TILE_SELECT:
				world.tileSelect();
			case MODE_BUILD:
				world.multipleTileSelect();
		}
	}
	
	private function multipleItemSelect(e:TileEvent):Void {
		var tile:WorldTile = cast e.target;
		menu.addMultipleItemSelect(e.items, tile.tileX, tile.tileY);
	}
	
	private function requestActions(e:ItemSelectEvent):Void {
		var item:WorldItem = cast e.target;
		var tile:WorldTile = cast item.parent;
		menu.addMultipleActions(e.actions, item.spriteCharCode, item.color, tile.tileX, tile.tileY);
	}
	
	private function enterFullscreen():Void {
		stage.displayState = StageDisplayState.FULL_SCREEN;
	}
	
	private function exitFullscreen():Void {
		stage.displayState = StageDisplayState.NORMAL;
	}
	
	private function exit():Void {
		System.exit(0);
	}
}
