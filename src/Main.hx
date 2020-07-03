package;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.Stage;
import openfl.display.StageDisplayState;
import openfl.events.KeyboardEvent;
import openfl.system.System;
import openfl.events.MouseEvent;

class Main extends Sprite 
{
	private static inline var SHIFT_MOVE_FACTOR:Int = 10;
	private var world:World = null;

	public function new() {
		super();
		
		// fullscreen
		var stage:Stage = stage;
		
		// keyboard listener
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		
		// world
		world = new World();
		addChild(world);
	}

	private function keyUp(e:KeyboardEvent):Void {
		switch (e.keyCode) {
			case 27: // esc
				if (stage.displayState == StageDisplayState.FULL_SCREEN) {
					exitFullscreen();
				} else {
					exit();
				}
			case 38: // up
				world.move(0, (e.shiftKey == true ? SHIFT_MOVE_FACTOR : 1) * -1);
			case 40: // down
				world.move(0, (e.shiftKey == true ? SHIFT_MOVE_FACTOR : 1));
			case 37: // left
				world.move((e.shiftKey == true ? SHIFT_MOVE_FACTOR : 1) * -1, 0);
			case 39: // right
				world.move((e.shiftKey == true ? SHIFT_MOVE_FACTOR : 1), 0);
			case 70: // f
				enterFullscreen();
			case 187: // +=
				if (e.shiftKey == true) {
					world.zoomIn();
				}
			case 189: // -_
				if (e.shiftKey == true) {
					world.zoomOut();
				}
			default:
		}
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
