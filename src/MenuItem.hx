package;
import openfl.display.Shape;

class MenuItem extends Item
{
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
		
		var background:Shape = new Shape();
		background.graphics.beginFill(0x000000);
		background.graphics.drawRect(0, 0, SpriteBitmapData.SPRITE_WIDTH, SpriteBitmapData.SPRITE_HEIGHT);
		background.graphics.endFill();
		addChild(background); 
	}
}