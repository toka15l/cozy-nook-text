package;
import menu.SelfAction;

class MenuActionItem extends MenuInteractiveItem
{
	public var selfAction:SelfAction;
	
	public function new(selfAction:SelfAction) {		
		super(selfAction.spriteCharCode, selfAction.color);
		this.selfAction = selfAction;
	}
}