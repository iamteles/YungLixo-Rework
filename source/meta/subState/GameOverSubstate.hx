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

class GameOverSubstate extends MusicBeatSubState
{
	//
	var pintowsDeath:Bool = false;
	
	var bf:Boyfriend;
	var camFollow:FlxObject;

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
				stageSuffix = '-pixel';
			case 'gemafunkin-player':
				daBf = 'gemafunkin-player';
			default:
				daBf = 'bf-dead';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend();
		bf.setCharacter(x, y + PlayState.boyfriend.height, daBf);
		add(bf);

		PlayState.boyfriend.destroy();

		camFollow = new FlxObject(bf.getGraphicMidpoint().x + 20, bf.getGraphicMidpoint().y - 40, 1, 1);
		add(camFollow);

		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
		
		if(PlayState.SONG.song.toLowerCase() == 'operational-system')
			pintowsDeath = true;
		
		if(!pintowsDeath)
		{
			FlxG.camera.flash(FlxColor.RED, 1, null, true);
			FlxTween.tween(FlxG.camera, {zoom: 0.5}, 1.2, {ease: FlxEase.expoOut});
		}
		else
		{
			Application.current.window.alert("Skill Issue :/", "Game Over");
			
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
		}
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

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
			FlxG.camera.follow(camFollow, LOCKON, 0.01);

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));

		// if (FlxG.sound.music.playing)
		//	Conductor.songPosition = FlxG.sound.music.time;
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
			if(!pintowsDeath) {
				FlxG.camera.flash(FlxColor.WHITE, 1, null, true);
				FlxTween.tween(FlxG.camera, {zoom: 1}, 0.65, {ease: FlxEase.expoOut});
			}
		
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
				{
					Main.switchState(this, new PlayState());
				});
			});
			//
		}
	}
}
