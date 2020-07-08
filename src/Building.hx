package;

class Building
{
	public var items:Array<Array<Any>> = [];
	private var startX:Int = null;
	private var startY:Int = null;
	
	public function new(startX:Int, startY:Int, endX:Int = null, endY:Int = null):Void {
		var startItem:TopLeft = new TopLeft();
		items.push([startItem, startX, startY]);
		this.startX = startX;
		this.startY = startY;
		if (endX != null && endY != null) {
			changeEnd(endX, endY);
		}
	}
	
	public function changeEnd(endX:Int, endY:Int):Void {
		items = [];
		// corners
		if (endX > startX) {
			if (endY > startY) {
				items.push([new TopLeft(), startX, startY]);
				items.push([new BottomRight(), endX, endY]);
				items.push([new TopRight(), endX, startY]);
				items.push([new BottomLeft(), startX, endY]);
			} else {
				items.push([new BottomLeft(), startX, startY]);
				items.push([new TopRight(), endX, endY]);
				items.push([new BottomRight(), endX, startY]);
				items.push([new TopLeft(), startX, endY]);
			}
		} else {
			if (endY > startY) {
				items.push([new TopRight(), startX, startY]);
				items.push([new BottomLeft(), endX, endY]);
				items.push([new TopLeft(), endX, startY]);
				items.push([new BottomRight(), startX, endY]);
			} else {
				items.push([new BottomRight(), startX, startY]);
				items.push([new TopLeft(), endX, endY]);
				items.push([new BottomLeft(), endX, startY]);
				items.push([new TopRight(), startX, endY]);
			}
		}
		// walls
		var wallStartX:Int = startX > endX ? endX : startX;
		var wallEndX:Int = startX > endX ? startX : endX;
		var wallStartY:Int = startY > endY ? endY : startY;
		var wallEndY:Int = startY > endY ? startY : endY;
		for (i in (wallStartX + 1)...wallEndX) {
			items.push([new Horizontal(), i, startY]);
			items.push([new Horizontal(), i, endY]);
		}
		for (i in (wallStartY + 1)...wallEndY) {
			items.push([new Vertical(), startX, i]);
			items.push([new Vertical(), endX, i]);
		}
	}
}

class Wall extends Item 
{	
	public function new() {
		color = 0x696969;
		super();
	}
}

class TopLeft extends Wall 
{
	public function new() {
		spriteCharCode = 201;
		super();
	}	
}

class TopRight extends Wall 
{
	public function new() {
		spriteCharCode = 187;
		super();
	}	
}

class BottomLeft extends Wall 
{
	public function new() {
		spriteCharCode = 200;
		super();
	}	
}

class BottomRight extends Wall 
{
	public function new() {
		spriteCharCode = 188;
		super();
	}	
}

class Horizontal extends Wall 
{
	public function new() {
		spriteCharCode = 205;
		super();
	}	
}

class Vertical extends Wall 
{
	public function new() {
		spriteCharCode = 186;
		super();
	}	
}