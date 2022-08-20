package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public static var sanAndreas:FNFSprite;
	public static var darkSouls:FNFSprite;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'potency' | 'big-boy':
					curStage = 'quarto';
				case 'collision':
					curStage = 'training';
				case 'killer-tibba':
					curStage = 'space';
				case 'operational-system':
					curStage = 'pintows';
				case 'keylogger':
					curStage = 'keylogger';
				case 'polygons':
					curStage = 'polygons';
				default:
					curStage = 'stage';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'quarto':
				PlayState.defaultCamZoom = 0.8;
				curStage = 'quarto';
				var bg:FNFSprite = new FNFSprite(350, 100).loadGraphic(Paths.image('backgrounds/gema/quarto'));
				bg.setGraphicSize(Std.int(bg.width * 2.2));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);
			case 'training':
				PlayState.defaultCamZoom = 0.8;
				curStage = 'training';
				var bg:FNFSprite = new FNFSprite(-900, -800).loadGraphic(Paths.image('backgrounds/gema/mugen'));
				bg.setGraphicSize(Std.int(bg.width * 0.75));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);
			case 'keylogger':
				PlayState.defaultCamZoom = 0.7; //0.7
				curStage = 'keylogger';
				var bg:FNFSprite = new FNFSprite(-700, -200).loadGraphic(Paths.image('backgrounds/gema/keylogged'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);
			case 'polygons':
				PlayState.defaultCamZoom = 0.65; //0.7
				curStage = 'polygons';
				var bg:FNFSprite = new FNFSprite(0, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/castle'));
				bg.antialiasing = true;
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				sanAndreas = new FNFSprite(-600, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/groove'));
				sanAndreas.antialiasing = true;
				sanAndreas.alpha = 0.0000001;
				sanAndreas.active = false;
				add(sanAndreas);

				darkSouls = new FNFSprite(-800, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/hell'));
				darkSouls.antialiasing = true;
				darkSouls.alpha = 0.0000001;
				darkSouls.active = false;
				add(darkSouls);
			case 'space':
				PlayState.defaultCamZoom = 0.6;
				curStage = 'space';

				var bg:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/space'));
				bg.setGraphicSize(Std.int(bg.width * 2.3));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.15, 0.15);
				bg.active = false;
				add(bg);

				var stars:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/stars'));
				stars.setGraphicSize(Std.int(stars.width * 2.3));
				stars.antialiasing = true;
				stars.scrollFactor.set(0.2, 0.2);
				stars.active = false;
				add(stars);

				var earth:FNFSprite = new FNFSprite(0, 200).loadGraphic(Paths.image('backgrounds/' + curStage + '/earth'));
				earth.setGraphicSize(Std.int(earth.width * 2.3));
				earth.antialiasing = true;
				earth.scrollFactor.set(0.3, 0.3);
				earth.active = false;
				add(earth);

				var ground:FNFSprite = new FNFSprite(0, 150).loadGraphic(Paths.image('backgrounds/' + curStage + '/ground'));
				ground.setGraphicSize(Std.int(ground.width * 3));
				ground.antialiasing = true;
				ground.scrollFactor.set(1, 1);
				ground.active = false;
				add(ground);
			case 'pintows':
				PlayState.defaultCamZoom = 1.05;
				curStage = 'pintows';

				var bg:FNFSprite = new FNFSprite(50, 1000).loadGraphic(Paths.image('backgrounds/' + curStage + '/pintow'));
				bg.antialiasing = true;
				bg.active = false;
				add(bg);
			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'highway':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray)
		{
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
					/*
						if (isStoryMode)
						{
							camPos.x += 600;
							tweenCamIn();
					}*/
					/*
						case 'spirit':
							var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
							evilTrail.changeValuesEnabled(false, false, false, false);
							add(evilTrail);
					 */
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'quarto':
				boyfriend.y -= 120;
				boyfriend.x += 140;
				dad.x += 50;
				dad.y -= 120;
				gf.y -= 100;
				gf.scrollFactor.set(1, 1);
			case 'training':
				gf.visible = false;
				dad.x -= 150;
				boyfriend.x += 150;
			case 'space':
				dad.x -= 500;
				dad.y += 80;
				boyfriend.x += 400;
				boyfriend.y += 40;
				gf.scrollFactor.set(1, 1);
			case 'pintows':
				gf.visible = false;
				gf.x += 40;
				gf.y += 890;
				dad.x += 150;
				dad.y += 755;
				boyfriend.y += 670;
				boyfriend.x -= 50;
			case 'keylogger':
				gf.visible = false;
				dad.x -= 140;
				dad.y += 60;
				boyfriend.y += 70;
				boyfriend.x -= 150;
			case 'polygons':
				dad.y -= 300;
				dad.x -= 150;
				boyfriend.x += 125;
				gf.visible = false;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
