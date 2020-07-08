package;

import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.StageDisplayState;
import openfl.events.KeyboardEvent;
import openfl.system.System;

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
		
		// fullscreen
		var stage:Stage = stage;
		
		// event listeners
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		addEventListener(Item.ItemSelectEvent.REQUEST_MENU_OBJECTS, requestMenuObjects);
		
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
				executeMode();
			case 27: // esc
				if (menu.isEmpty() == false) {
					menu.emptyAllTiles();
				} else {
					stage.displayState == StageDisplayState.FULL_SCREEN ? exitFullscreen() : exit();
				}
			case 37: // left
				world.move((e.shiftKey == true ? SHIFT_MOVE_MULTIPLIER : 1) * -1, 0);
			case 38: // up
				world.move(0, (e.shiftKey == true ? SHIFT_MOVE_MULTIPLIER : 1) * -1);
			case 40: // down
				world.move(0, (e.shiftKey == true ? SHIFT_MOVE_MULTIPLIER : 1));
			case 39: // right
				world.move((e.shiftKey == true ? SHIFT_MOVE_MULTIPLIER : 1), 0);
			case 66: // b
				currentMode = MODE_BUILD;
			case 70: // f
				enterFullscreen();
			case 75: // k
				currentMode = MODE_SINGLE_TILE_SELECT;
			case 187: // +=
				e.shiftKey == true ? world.zoomIn() : null;
			case 189: // -_
				e.shiftKey == true ? world.zoomOut() : null;
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
	
	private function requestMenuObjects(e:Item.ItemSelectEvent):Void {
		menu.addMultipleMenuObjects(e.menuObjects, 1, 7);
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
