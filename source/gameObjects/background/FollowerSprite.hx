package gameObjects.background;

import flixel.FlxG;
import flixel.math.FlxMath;
import meta.CoolUtil;
import meta.data.dependency.FNFSprite;

// eu real só fiz isso por causa da vaca medonha, mas da pra usar com qualquer sprite
class FollowerSprite extends FNFSprite
{
	public var followX:Float = 0;
	public var followY:Float = 0;
	public var followAngle:Float = 0;
	public var speed:Float = 0.1;
	
	public function new(x:Float, y:Float, daImage:String)
	{
		super(x, y);
		loadGraphic(Paths.image(daImage));
		
		// making it spawn
		followX = x;
		followY = y;
		
		scale.set(0.8, 0.8);
		updateHitbox();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		x = FlxMath.lerp(x, followX, speed);
		y = FlxMath.lerp(y, followY, speed);
		//angle = FlxMath.lerp(angle, followAngle, speed);
	}
}