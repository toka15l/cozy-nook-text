package;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.Stage;
import openfl.display.StageDisplayState;
import openfl.events.KeyboardEvent;
import openfl.system.System;
//import Foreground.ForegroundEvent;
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
	
		// black background
		//var background:SolidBackground = new SolidBackground(0xFF0000, 20, 20);
		//addChild(background);
	
		// scaling
		var maxScaleWidth:Int = Math.floor(Lib.application.window.width / baseWidth);
		var maxScaleHeight:Int = Math.floor(Lib.application.window.height / baseHeight);
		var scale:Int = maxScaleWidth;
		if (scale > maxScaleHeight) {
			scale = maxScaleHeight;
		}
		//scaleX = scaleY = scale;
		
		// center
		//x = Math.floor((Lib.application.window.width - width) / 2);
		//y = Math.floor((Lib.application.window.height - height) / 2);
		
		// mask
		var stageMask:SolidBackground = new SolidBackground(0x00FF00, baseWidth, baseHeight);
		stageMask.scaleX = stageMask.scaleY = scale;
		stageMask.x = x;
		stageMask.y = y;
		mask = stageMask;
		
		// keyboard listener
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		
		// mouse listener
		//stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		
		// checkout
		/*var checkout:Checkout = new Checkout();
		checkout.addEventListener(ForegroundEvent.OPEN_FOREGROUND, openForeground);
		addChild(checkout);*/
		
		//var pack:Pack = new Pack();
		//addChild(pack);
		
		var graphic:Graphic = new Graphic();
		var dwarf:BitmapMovieClip = new BitmapMovieClip(graphic.DWARF);		
		addChild(dwarf);
	}
	
	/*private function openForeground(e:ForegroundEvent) {
		if (e.button.foreground == "book") {
			foreground = new Book(e.button);
		}
		if (foreground != null) {
			addChild(foreground);
		}
	}
	
	private function closeForeground(e:MouseEvent) {
		if (foreground != null) {
			if (foreground.button != null) {
				foreground.button.visible = true;
			}
			removeChild(foreground);
			foreground = null;
		}
	}
	
	private function mouseUp(e:MouseEvent) {
		// close foreground if clicked outside
		if (foreground != null) {
			var foregroundClicked:Bool = false;
			var currentTarget:DisplayObjectContainer = e.target;
			while (currentTarget != null) {
				if (currentTarget == foreground) {
					foregroundClicked = true;
					break;
				}
				currentTarget = currentTarget.parent;				
			}
			if (foregroundClicked == false) {
				closeForeground(null);
			}
		}
	}*/

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
