package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
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
	var elapsedtime:Float = 0;

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

	//yung lixo!!1!!
	public static var gemaplysPuxada:GemaplysPuxada;
	var farmNuvens:FlxSprite; // bg antigo
	var farmFan:FNFSprite;
	public static var presidenteCoisa:FNFSprite;
	
	var pessoalTras:FlxSprite;
	var pessoalFrente:FlxSprite;

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
				case 'jokes':
					curStage = 'farm';
				case 'crazy-pizza':
					curStage = 'miner';
				case 'back-to-black':
					curStage = 'btb';
				case 'kkkri':
					curStage = "daiane";
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
				
				// puxada funny
				gemaplysPuxada = new GemaplysPuxada(-1230, 100);
				foreground.add(gemaplysPuxada);
				
			case 'training':
				PlayState.defaultCamZoom = 0.8;
				curStage = 'training';
				var bg:FNFSprite = new FNFSprite(-900, -800).loadGraphic(Paths.image('backgrounds/gema/mugen'));
				bg.setGraphicSize(Std.int(bg.width * 0.75));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);
			case 'farm':
				PlayState.defaultCamZoom = 0.9; //não importa mesmo, o playstate vai mudar ele
				curStage = 'farm';
				
				var bgmultiplier:Int = 2;
				
				var bg:FNFSprite = new FNFSprite(130,-10).loadGraphic(Paths.image('backgrounds/${curStage}/sky'));
				//bg.setGraphicSize(bg.width * 1.5);
				bg.scale.set(1.65,1.65);
				bg.scrollFactor.set(0.8,0.5);
				bg.active = false;
				add(bg);
				
				farmNuvens = new FlxBackdrop(Paths.image('backgrounds/${curStage}/nuvens'), 1, 1, true, false, 1, 1);
				farmNuvens.alpha = 0.8;
				farmNuvens.velocity.x = -30;
				farmNuvens.x = 300;
				add(farmNuvens);
				farmNuvens.visible = false;
				
				// windmil
				/*
				var bg:FNFSprite = new FNFSprite(1200,300).loadGraphic(Paths.image('backgrounds/${curStage}/spr_windmill'));
				bg.setGraphicSize(Std.int(bg.width * 4));
				bg.scrollFactor.set(0.7,1);
				bg.active = false;
				add(bg);
				*/
				//400
				
				var bg:FNFSprite = new FNFSprite(180,90).loadGraphic(Paths.image('backgrounds/${curStage}/cerca'));
				bg.setGraphicSize(Std.int(bg.width * bgmultiplier));
				bg.scrollFactor.set(0.98,1);
				bg.active = false;
				add(bg);
				
				farmFan = new FNFSprite(bg.x + 450, bg.y - 100).loadGraphic(Paths.image('backgrounds/${curStage}/spr_windmillfan'));
				farmFan.setGraphicSize(Std.int(farmFan.width * 6));
				farmFan.scrollFactor.set(0.98,1);
				farmFan.active = false;
				add(farmFan);
				// windmil
				
				var bg:FNFSprite = new FNFSprite(-300,600).loadGraphic(Paths.image('backgrounds/${curStage}/ground'));
				bg.setGraphicSize(Std.int(bg.width * bgmultiplier));
				bg.scrollFactor.set(1,1);
				bg.active = false;
				add(bg);

				if(PlayState.storyDifficulty == 1)
				{
					// 266, 464
					// 50 -50
					presidenteCoisa = new FNFSprite(50,-50).loadGraphic(Paths.image('backgrounds/${curStage}/presidente'));
					presidenteCoisa.scrollFactor.set(1,1);
					presidenteCoisa.active = false;
					presidenteCoisa.alpha = 0.00001;
					add(presidenteCoisa);
				}
				
				
			case 'keylogger':
				PlayState.defaultCamZoom = 0.7; //0.7
				curStage = 'keylogger';
				var bg:FNFSprite = new FNFSprite(-700, -200).loadGraphic(Paths.image('backgrounds/gema/keylogged'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);
			case 'daiane':
				PlayState.defaultCamZoom = 0.65; //0.7
				curStage = 'daiane';

				var bg:FNFSprite = new FNFSprite(0, 200).loadGraphic(Paths.image('backgrounds/polygons/castleNEW'));
				bg.antialiasing = true;
				bg.setGraphicSize(Std.int(bg.width * 2));
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
				bg.scrollFactor.set(0.15, 0.5);
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
				earth.scrollFactor.set(0.3, 0.6);
				earth.active = false;
				add(earth);

				var ground:FNFSprite = new FNFSprite(0, 130).loadGraphic(Paths.image('backgrounds/' + curStage + '/ground'));
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
			case 'miner':
				PlayState.defaultCamZoom = 0.75; // depois o zoom diminui no começo da musica
				curStage = 'miner';
				
				var bg:FNFSprite = new FNFSprite(100,-300).loadGraphic(Paths.image('backgrounds/' + curStage + '/fundo'));
				bg.scale.set(3,3);
				bg.antialiasing = true;
				bg.active = false;
				add(bg);
				
				if(PlayState.storyDifficulty == 1)
				{
					pessoalTras = new FlxSprite(-170,150);
					pessoalTras.frames = Paths.getSparrowAtlas('backgrounds/${curStage}/bgCharacters');
					pessoalTras.animation.addByPrefix('idle', "pessoal de tras", 24, false);
					pessoalTras.scale.set(1.4,1.4);
					pessoalTras.animation.play('idle');
					pessoalTras.scrollFactor.set(1,1);
					add(pessoalTras);
				
					pessoalFrente = new FlxSprite(-320, 1060);
					pessoalFrente.frames = Paths.getSparrowAtlas('backgrounds/${curStage}/bgCharacters');
					pessoalFrente.animation.addByPrefix('idle', "pessoal da frente", 24, false);
					pessoalFrente.setGraphicSize(Std.int(pessoalFrente.width * 2));
					pessoalFrente.animation.play('idle');
					pessoalFrente.scrollFactor.set(2.75,1.3);
					foreground.add(pessoalFrente);
				}
				
			case 'btb':
				PlayState.defaultCamZoom = 0.6;
				curStage = 'btb';
				
				var bg:FNFSprite = new FNFSprite(-200,-200).loadGraphic(Paths.image('backgrounds/gema/back-to-black'));
				bg.setGraphicSize(Std.int(bg.width * 2));
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
			case 'farm':
				gfVersion = 'gf-pixel';
			case 'miner':
				gfVersion = 'gf-miner';
		}
		
		// aaaaaaa
		if(PlayState.storyDifficulty == 1 && PlayState.SONG.song.toLowerCase() != 'jokes')
			gfVersion = 'gf-miner';

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
				boyfriend.y -= 10;
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
				dad.y += 755 - 160;
				boyfriend.y += 670 - 160;
				boyfriend.x -= 50;
			case 'miner':
				if(PlayState.storyDifficulty == 1)
					gf.visible = false;
				
				gf.x += 40;
				dad.y += 150;
				boyfriend.y += 150;
				
				dad.x -= 100;
				boyfriend.x += 100;
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
			case 'farm':
				dad.x += 430;
				dad.y += 8;
				boyfriend.x += 500;
				gf.x += 500;
				gf.y += 160;
			case 'btb':
				gf.y -= 160;
				dad.x -= 150;
				boyfriend.x += 150;
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
			case 'miner':
				if(PlayState.storyDifficulty == 1)
				{
					if(curBeat % 2 == 0) pessoalTras.animation.play('idle');
					if(curBeat % 2 == 1) pessoalFrente.animation.play('idle');
				}
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
		elapsedtime += (elapsed * Math.PI);
	
		switch (PlayState.curStage)
		{
			case 'farm':
				farmFan.angle += -150 * elapsed;
				//farmFan.angle = 360 * (Math.tan(elapsedtime)) * 50; // windstorm mode
				if(PlayState.storyDifficulty == 1)
				{
					presidenteCoisa.x = PlayState.tibba.x - 216;
					presidenteCoisa.y = PlayState.tibba.y - 118; // 150 mt pra cima
				}
		
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
