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
	private var baseWidth:Int = 80;
	private var baseHeight:Int = 45;

	public function new() 
	{
		super();
		
		// fullscreen
		var stage:Stage = stage;
		if (testing == false) {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		// keyboard listener
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		
		var graphic:Graphic = new Graphic();
		var dwarf:BitmapMovieClip = new BitmapMovieClip(graphic.DWARF);		
		addChild(dwarf);
		
		scaleX = scaleY = Settings.INITIAL_SCALE;
	}

	private function keyUp(e:KeyboardEvent):Void {
		// esc key
		if (e.keyCode == 27) {
			exit();
		}
		// up arrow
		if (e.keyCode == 38) {
			changeScale(1);
		}
		// down arrow
		if (e.keyCode == 40) {
			changeScale(-1);
		}
	}
	
	private function exit():Void {
		System.exit(0);
	}
	
	private function changeScale(change:Int):Void {
		if (scaleX + change <= 0) {
			return;
		}
		scaleX += change;
		scaleY += change;
	}
}
