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
	private var testing:Bool = true;

	public function new() {
		super();
		
		// fullscreen
		var stage:Stage = stage;
		if (testing == false) {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		// keyboard listener
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		
		var graphic:World = new World();
		var dwarf:BitmapMovieClip = new BitmapMovieClip(graphic.DWARF);		
		addChild(dwarf);
		
		scaleX = scaleY = Settings.INITIAL_SCALE;
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
			case 40: // down arrow
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
