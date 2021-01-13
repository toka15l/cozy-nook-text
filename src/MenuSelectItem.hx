package;

class MenuSelectItem extends MenuInteractiveItem
{
	public var item:WorldItem;
	
	public function new(item:WorldItem) {
		super(item.spriteCharCode, item.color);		
		this.item = item;
	}
}