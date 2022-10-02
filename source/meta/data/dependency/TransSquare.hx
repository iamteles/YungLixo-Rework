package meta.data.dependency;

import flixel.FlxG;

// funny trans square
class TransSquare extends FNFSprite
{
	var transIn:Bool;
	
	public function new(transIn:Bool)
	{
		super();
		this.transIn = transIn;
		
		frames = Paths.getSparrowAtlas('UI/transition/funky_squares');
		animation.addByPrefix('shitballs', 'going', 36, false);
		playAnim('shitballs', true, transIn);
		
		x = ((FlxG.width / 2) - (width / 2));
		y = ((FlxG.height / 2) - (height / 2));
	}
}