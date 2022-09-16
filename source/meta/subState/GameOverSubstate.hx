package meta.subState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import gameObjects.Boyfriend;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.Conductor.BPMChangeEvent;
import meta.data.Conductor;
import meta.state.*;
import meta.state.menus.*;
import lime.app.Application;

using StringTools;

class GameOverSubstate extends MusicBeatSubState
{
	//
	var customDeath:String = 'none';
	
	var bf:Boyfriend;
	var camFollow:FlxObject;
	var chickenFallSpeed:Float = -30;

	public static var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daBoyfriendType = PlayState.boyfriend.curCharacter;
		var daBf:String = '';
		switch (daBoyfriendType)
		{
			case 'bf-og':
				daBf = daBoyfriendType;
			case 'bf-pixel':
				daBf = 'bf-pixel-dead';
				//stageSuffix = '-pixel';
			case 'gemafunkin-player':
				daBf = 'gemafunkin-player';
			case 'chicken-player' | 'chicken-player-pixel':
				daBf = daBoyfriendType;
			default:
				daBf = 'bf-dead';
		}
		if(daBoyfriendType == 'bf-pixel')
			stageSuffix = '-pixel';
		else
			stageSuffix = '';

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend();
		bf.setCharacter(x, y + PlayState.boyfriend.height, daBf);
		add(bf);
		
		// COLOCA AS MORTES CUSTOM AQUI
		switch(PlayState.SONG.song.toLowerCase())
		{
			case 'operational-system':
				customDeath = 'pintows';
			default:
				customDeath = 'none';
				
				if(daBf.startsWith('chicken'))
					customDeath = 'chicken';
		}
		switch(customDeath)
		{
			default:
				FlxG.camera.flash(FlxColor.RED, 1, null, true);
				FlxTween.tween(FlxG.camera, {zoom: 0.5}, 1.2, {ease: FlxEase.expoOut});
				bf.playAnim('firstDeath');
			
			case 'pintows': // die!!!!
				var daWindow = Application.current.window;
				daWindow.fullscreen = false;
				daWindow.alert("Skill Issue :/", "Game Over");
			
				bf.alpha = 0.0001; // nobody likes you
			
				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/pintows/death'));
				bg.antialiasing = true;
				bg.scrollFactor.set();
				add(bg);
			
				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/pintows/overlay'));
				bg.antialiasing = true;
				bg.scrollFactor.set();
				bg.scale.set(0.97,0.97);
				add(bg);
				
			case 'chicken':
				bf.playAnim('death');
		}
		
		camFollow = new FlxObject(bf.getGraphicMidpoint().x + 20, bf.getGraphicMidpoint().y - 40, 1, 1);
		add(camFollow);

		PlayState.boyfriend.destroy();
		
		Conductor.changeBPM(120); //100
		
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;
		
		FlxG.camera.follow(camFollow, LOCKON, 0.01);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			endBullshit();

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deaths = 0;

			if (PlayState.isStoryMode)
			{
				Main.switchState(this, new StoryMenuState());
			}
			else
				Main.switchState(this, new FreeplayState());
		}

		switch(customDeath)
		{
			default:
				//if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
					FlxG.camera.follow(camFollow, LOCKON, 0.01);

				if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
					FlxG.sound.playMusic(Paths.music('gameOver'));
					
			case 'pintows':
				// nada
					
			case 'chicken':
				// tem que deixar ele mais pesado quando ele é pixel se não ele VOA PRA KRL
				chickenFallSpeed += ((bf.curCharacter == 'chicken-player-pixel') ? 100 : 50) * elapsed;
				
				bf.x += 450 * elapsed;
				bf.y += chickenFallSpeed;
				
				bf.angle += 600 * elapsed;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			// é pra não tocar 
			switch(customDeath)
			{
				case 'pintows':
					// nada
				case 'chicken':
					// nada
				default:
					FlxG.camera.flash(FlxColor.WHITE, 1.2, null, true);
					FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.expoOut});
					bf.playAnim('deathConfirm', true);
			}
		
			isEnding = true;
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd'));
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1.42, false, function()
				{
					Main.switchState(this, new PlayState());
				});
			});
			//
		}
	}
}
