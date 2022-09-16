package gameObjects.background;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import meta.CoolUtil;
import meta.data.dependency.FNFSprite;
import gameObjects.Character;

class GemaplysPuxada extends FNFSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		frames = Paths.getSparrowAtlas('backgrounds/gema/gemaplysPUXADA');
		
		animation.addByPrefix('puxada', "puxada0", 24, false);
		animation.play('puxada');
		setGraphicSize(Std.int(width * 1.2));
		alpha = 0.0001;
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		// morre
		if(animation.curAnim.curFrame >= 26)
			alpha = 0.0001;
			
		// arrumador de offset 2000
		/*
		var mult:Int = (FlxG.keys.pressed.SHIFT ? 0.1 : 1);
		if(FlxG.keys.pressed.LEFT) x -= 5 * mult;
		if(FlxG.keys.pressed.RIGHT)x += 5 * mult;
		if(FlxG.keys.pressed.UP)   y -= 5 * mult;
		if(FlxG.keys.pressed.DOWN) y += 5 * mult;
		*/
		if(FlxG.keys.justPressed.SPACE) trace('X is: ${x} Y is: ${y}');
	}
	
	public function puxar(char:Character)
	{
		// pra sincronizar e nn ficar estranho
		if(char.animation.curAnim.name == 'idle' && char.animation.curAnim.curFrame == 0 && char.alpha > 0.5)
		{
			char.alpha = 0.0001;
			this.alpha = 1;
			this.animation.play('puxada');
		}
	}
}