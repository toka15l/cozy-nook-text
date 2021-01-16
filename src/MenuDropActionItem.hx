package;
import menu.DropAction;

class MenuDropActionItem extends MenuInteractiveItem
{
	public var dropAction:DropAction;
	
	public function new(dropAction:DropAction) {		
		super(dropAction.spriteCharCode, dropAction.color);
		this.dropAction = dropAction;
	}
}