package;
import menu.Action;

class MenuActionItem extends MenuInteractiveItem
{
	public var action:Action;
	
	public function new(action:Action) {		
		super(action.spriteCharCode, action.color);
		this.action = action;
	}
}