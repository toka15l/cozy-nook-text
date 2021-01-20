package;
import menu.SelfAction;

class MenuSelfActionItem extends MenuInteractiveItem
{
	public var selfAction:SelfAction;
	
	public function new(selfAction:SelfAction) {		
		super(selfAction.spriteCharCode, selfAction.color);
		this.selfAction = selfAction;
	}
}