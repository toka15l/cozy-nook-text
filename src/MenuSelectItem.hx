package;
import openfl.display.Shape;

class MenuSelectItem extends MenuItem
{
	public var selected:Bool = false;
	private var highlight:Shape;
	
	public function new(spriteCharCode:Int, color:Int = null) {
		super(spriteCharCode, color);
		
		highlight = new Shape();
		highlight.graphics.beginFill(0xFFFFFF);
		highlight.graphics.drawRect(0, 0, SpriteBitmapData.SPRITE_WIDTH, SpriteBitmapData.SPRITE_HEIGHT);
		highlight.graphics.endFill();
		highlight.visible = false;
		addChild(highlight); 
	}
	
	public function select(select:Bool):Void {
		selected = select;
		highlight.visible = select;
	}
}