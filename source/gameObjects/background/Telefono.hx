package gameObjects.background;

import meta.data.dependency.FNFSprite;

class Telefono extends FNFSprite
{
	var elapsedtime:Float = 0;
	var startY:Float = 0;
	public function new(x:Float, y:Float)
	{
		//telefono = new FlxSprite(-230, 500); //425
		super(x, y);
		startY = y;
		
		frames = Paths.getSparrowAtlas('backgrounds/farm/telefono');
		animation.addByPrefix('idle', "ringing 9", 24, false);
		animation.addByPrefix('ringing', "ringing", 24, false);
		animation.play('idle');
		scale.set(2,2);
	}
	
	// é pra vua
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	
		elapsedtime += elapsed * Math.PI;
		y = startY - Math.sin(elapsedtime) * 20;
		
		// não quero atrapalhar a animaçãozinha po
		if(animation.curAnim.name != 'ringing')
			angle = Math.sin(elapsedtime) * 10;
	}
}