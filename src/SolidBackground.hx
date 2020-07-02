package;
import openfl.display.MovieClip;
import openfl.display.Shape;

class SolidBackground extends MovieClip 
{
	public var background:Shape;
	
	public function new(backgroundColor:Int, backgroundWidth:Int, backgroundHeight:Int, backgroundAlpha:Float = 1) 
	{
		super();
		
		background = new Shape();
		background.graphics.beginFill(backgroundColor, backgroundAlpha);
		background.graphics.drawRect(0, 0, backgroundWidth, backgroundHeight);
		background.graphics.endFill();
		addChild(background);
	}
	
}