package gameObjects.background;

import flixel.FlxG;
import flixel.math.FlxMath;
import meta.CoolUtil;
import meta.data.dependency.FNFSprite;

class Barra extends FNFSprite
{
	public var isOnTop:Bool = false;
	public var isOffscreen:Bool = true;
	var speed:Float = 0.08;
	
	public function new(isOnTop:Bool)
	{
		super();
		this.isOnTop = isOnTop;
		
		// making the bar
		makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 1.2), 0xFF000000);
		x = (FlxG.width / 2) - (this.width / 2);
		// placing it
		if(isOnTop)
			y = 0 - this.height;
		else
			y = FlxG.height;
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		// I HATE MATH SO MUCH AAAAAAAAAAAAAAAAAAAAAA
		if(isOnTop)
			y = FlxMath.lerp(y,  0 - height + (isOffscreen ? 0 : 110), speed);
		else
			y = FlxMath.lerp(y, FlxG.height - (isOffscreen ? 0 : 110), speed);
	}
}