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
			case 38: // up arrow
				world.zoomIn();
			case 40: // down arrow
				world.zoomOut();
			case 37: // left
				world.move(world.DIRECTION_LEFT);
			case 39: // right
				world.move(world.DIRECTION_RIGHT);
			case 70: // f
				enterFullscreen();
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
