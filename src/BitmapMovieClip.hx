package;
import openfl.display.MovieClip;
import openfl.display.Bitmap;

class BitmapMovieClip extends MovieClip
{
	private var bitmap:Bitmap;
	
	public function new(bitmap:Bitmap) 
	{
		super();
		
		addChild(bitmap);
	}
}