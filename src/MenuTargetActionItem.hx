package;
import menu.TargetAction;

class MenuTargetActionItem extends MenuInteractiveItem
{
	public var targetAction:TargetAction;
	
	public function new(targetAction:TargetAction) {		
		super(targetAction.spriteCharCode, targetAction.color);
		this.targetAction = targetAction;
	}
}