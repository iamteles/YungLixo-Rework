package gameObjects;

/**
	The character class initialises any and all characters that exist within gameplay. For now, the character class will
	stay the same as it was in the original source of the game. I'll most likely make some changes afterwards though!

	i changed it
	  --diogo
**/
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.addons.util.FlxSimplex;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import gameObjects.userInterface.HealthIcon;
import meta.*;
import meta.data.*;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

typedef CharacterData =
{
	var offsetX:Float;
	var offsetY:Float;
	var camOffsetX:Float;
	var camOffsetY:Float;
	var quickDancer:Bool;
}

class Character extends FNFSprite
{
	//public var debugMode:Bool = false;

	public var startX:Float = 0;
	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var specialAnim:Bool = false;

	public var holdTimer:Float = 0;

	public var characterData:CharacterData;
	public var adjustPos:Bool = true;

	public var isNativelyPlayer:Bool = false;

	public function new(?isPlayer:Bool = false)
	{
		super(x, y);
		this.isPlayer = isPlayer;
	}

	public function setCharacter(x:Float, y:Float, character:String):Character
	{
		curCharacter = character;
		var tex:FlxAtlasFrames;
		antialiasing = true;

		characterData = {
			offsetY: 0,
			offsetX: 0,
			camOffsetY: 0,
			camOffsetX: 0,
			quickDancer: false
		};

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
				
			case 'gf-miner':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_MINERINHO');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');
				
				characterData.offsetY = -10;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				playAnim('idle');

			case 'bf':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);

				playAnim('idle');

				flipX = true;

				characterData.offsetY = 70;

				isNativelyPlayer = true;

			case 'bf-reshaped':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND_R');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				playAnim('idle');

				flipX = true;

				characterData.offsetY = 0; //70
				characterData.camOffsetY = 35; //70

				//isNativelyPlayer = true;

			case 'bf-psych':
				frames = Paths.getSparrowAtlas('characters/bf-psych');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);

				playAnim('idle');

				flipX = true;

				isNativelyPlayer = true;

			case 'bf-dead':
				frames = Paths.getSparrowAtlas('characters/BF_DEATH');

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				playAnim('firstDeath');

				flipX = true;

				isNativelyPlayer = true;

			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
				animation.addByPrefix('dodge', 'BF DODGE', 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

				isNativelyPlayer = true;

				if(PlayState.SONG.song.toLowerCase() == 'jokes')
					characterData.camOffsetX = 300;

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

				characterData.offsetY = 180;

				isNativelyPlayer = true;

			case 'gemaplys':
				tex = Paths.getSparrowAtlas('characters/gemaplys');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singLEFT', 'left', 24);

				characterData.camOffsetY = 70;
				characterData.camOffsetX = 180;

				setGraphicSize(Std.int(width * 1.2));
				updateHitbox();

				playAnim('idle');

			case 'yunglixo':
				tex = Paths.getSparrowAtlas('characters/yl');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singLEFT', 'left', 24);

				characterData.offsetY = -210;
				characterData.offsetX = -90;
				characterData.camOffsetY = 250;
				characterData.camOffsetX = 290;

				setGraphicSize(Std.int(width * 1.2));
				updateHitbox();

				playAnim('idle');

			case 'tibba':
				tex = Paths.getSparrowAtlas('characters/tiba');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singLEFT', 'left', 24);
				
				setGraphicSize(Std.int(width * 1.3));
				updateHitbox();

				playAnim('idle');

			case 'mugen':
				tex = Paths.getSparrowAtlas('characters/gemamugen');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singLEFT', 'left', 24);
				animation.addByPrefix('hey', 'chacharealsmooth', 24, true);
				setGraphicSize(Std.int(width * 2));

				playAnim('idle');

			case 'vito':
				tex = Paths.getSparrowAtlas('characters/vito');
				frames = tex;
				animation.addByPrefix('idle', 'SCHIAVONESkt_IDLE', 24, false);
				animation.addByPrefix('singUP', 'SCHIAVONESkt_UP', 24);
				animation.addByPrefix('singRIGHT', 'SCHIAVONESkt_RIGHT', 24);
				animation.addByPrefix('singDOWN', 'SCHIAVONESkt_DOWN', 24);
				animation.addByPrefix('singLEFT', 'SCHIAVONESkt_LEFT', 24);

				setGraphicSize(Std.int(width * 1.4));
				updateHitbox();

				characterData.camOffsetX = 300;

				playAnim('idle');
			case 'mineirinho':
				tex = Paths.getSparrowAtlas('characters/mineirinhoSprites');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singLEFT', 'left', 24);

				animation.addByPrefix('startNORMAL', 'startN', 24);
				animation.addByPrefix('startRESHAPED', 'startR', 24);
				animation.addByPrefix('pimentinha', 'pimentinha', 24);

				characterData.camOffsetY = 150;

				playAnim('idle');
			case 'mc-vv':
				tex = Paths.getSparrowAtlas('characters/Mc_VV');
				frames = tex;
				//animation.addByPrefix('idle', 'Mc VV Idle', 24, false);
				animation.addByIndices('danceLeft', 'Mc VV Idle', [0,1,2,3,4,5], "", 16, false);
				animation.addByIndices('danceRight','Mc VV Idle', [6,7,8,9,10,11,12], "", 16, false);

				animation.addByPrefix('singUP', 'Mc VV Up', 16);
				animation.addByPrefix('singRIGHT', 'Mc VV Right', 16);
				animation.addByPrefix('singDOWN', 'Mc VV Down', 16);
				animation.addByPrefix('singLEFT', 'Mc VV Left', 16);

				characterData.camOffsetX = -250;
				characterData.camOffsetY = 115;

				characterData.quickDancer = true;

				playAnim('idle');

			case 'mamaco':
				tex = Paths.getSparrowAtlas('characters/mamaco');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24);
				animation.addByPrefix('singRIGHT', 'right', 24);
				animation.addByPrefix('singDOWN', 'down', 24);
				animation.addByPrefix('singLEFT', 'left', 24);
				setGraphicSize(Std.int(width * 0.5));

				playAnim('idle');

			case 'vindisio':
				tex = Paths.getSparrowAtlas('characters/vindisio');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', false);
				animation.addByPrefix('singDOWN', 'down', false);
				animation.addByPrefix('singLEFT', 'left', false);
				animation.addByPrefix('singUPmiss', 'up', false);
				animation.addByPrefix('singRIGHTmiss', 'right', false);
				animation.addByPrefix('singDOWNmiss', 'down', false);
				animation.addByPrefix('singLEFTmiss', 'left', false);

				setGraphicSize(Std.int(width * 0.6));

				playAnim('idle');

				isNativelyPlayer = false;

			case 'turbo':
				tex = Paths.getSparrowAtlas('characters/turbo');
				frames = tex;
				animation.addByPrefix('idle', 'TURBO_idle', 24, false);
				animation.addByPrefix('singUP', 'TURBO_up', 24);
				animation.addByPrefix('singRIGHT', 'TURBO_right', 24);
				animation.addByPrefix('singDOWN', 'TURBO_down', 24);
				animation.addByPrefix('singLEFT', 'TURBO_left', 24);

				playAnim('idle');

				characterData.camOffsetX = 300;

			case 'turboAngry':
				tex = Paths.getSparrowAtlas('characters/turbo_dois');
				frames = tex;
				animation.addByPrefix('idle', 'TURBOTIBBA_idle', 24, false);
				animation.addByPrefix('singUP', 'TURBOTIBBA_up', 24);
				animation.addByPrefix('singRIGHT', 'TURBOTIBBA_right', 24);
				animation.addByPrefix('singDOWN', 'TURBOTIBBA_down', 24);
				animation.addByPrefix('singLEFT', 'TURBOTIBBA_left', 24);

				playAnim('idle');

			case 'tibba-pixel':
				tex = Paths.getSparrowAtlas('characters/Tibba_PIXEL_ASSETS');
				frames = tex;
				animation.addByPrefix('idle', 'Tibba Idle', 24, false);
				animation.addByPrefix('singUP', 'Tibba Up', 24);
				animation.addByPrefix('singRIGHT', 'Tibba Right', 24);
				animation.addByPrefix('singDOWN', 'Tibba Down', 24);
				animation.addByPrefix('singLEFT', 'Tibba Left', 24);

				setGraphicSize(Std.int(width * 3.9));
				updateHitbox();
				antialiasing = false;

				playAnim('idle');
			case 'gemafunkin':
				tex = Paths.getSparrowAtlas('characters/gemaFunkinAss');
				frames = tex;
				animation.addByPrefix('idle', 'gema idle', 24, false);
				animation.addByPrefix('singUP', 'gema up', 24);
				animation.addByPrefix('singRIGHT', 'gema right', 24);
				animation.addByPrefix('singDOWN', 'gema down', 24);
				animation.addByPrefix('singLEFT', 'gema left', 24);
				updateHitbox();

				characterData.camOffsetX = 260;
				characterData.offsetX = 150;
				characterData.offsetY = -30;

				playAnim('idle');

			case 'gemafunkin-player':
				tex = Paths.getSparrowAtlas('characters/gemaFunkinPlayerAss');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('hey', 'hey', 24, false);
				animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);

				animation.addByPrefix('singUPmiss', 'up miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'right miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'down miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'left miss', 24, false);

				//collision
				animation.addByPrefix('dodge', 'up0', 24);

				// die!!1!
				animation.addByPrefix('firstDeath', "death", 24, false);
				animation.addByIndices('deathLoop', "death", [25], "", 0, false);
				animation.addByPrefix('deathConfirm', "death", 24, false);

				updateHitbox();

				if(PlayState.SONG.song.toLowerCase() == 'collision'
				|| PlayState.SONG.song.toLowerCase() == 'jokes')
				{
					characterData.offsetX = -300;
					characterData.offsetY = -75;

					if(PlayState.SONG.song.toLowerCase() == 'collision') characterData.camOffsetX = -200;
					if(PlayState.SONG.song.toLowerCase() == 'jokes') {
						characterData.camOffsetX = 200;
						characterData.camOffsetY = 120;
					}
				}
				else
				{
					characterData.offsetX = -125;
					characterData.offsetY = 100;
					characterData.camOffsetY = 125;
				}

				// now i added miss animations
				isNativelyPlayer = true;
				flipX = true;

				playAnim('idle');

			case 'gemafunkin-select':
				tex = Paths.getSparrowAtlas('characters/gemaFunkinAss');
				frames = tex;
				animation.addByPrefix('idle', 'gema idle', 24, false);
				animation.addByPrefix('hey', 'gema hey', 24, false);

				playAnim('idle');

				//flipX = true;

			case 'gema64':
				tex = Paths.getSparrowAtlas('characters/Gema64');
				frames = tex;
				animation.addByPrefix('idle', 'gema69_idle', 24, false);
				animation.addByPrefix('singUP', 'gema69_up', 24);
				animation.addByPrefix('singRIGHT', 'gema69_right', 24);
				animation.addByPrefix('singDOWN', 'gema69_down', 24);
				animation.addByPrefix('singLEFT', 'gema69_left', 24);
				updateHitbox();

				playAnim('idle');

				characterData.camOffsetY = 250;
				characterData.camOffsetX = 290;

			case 'gema3d':
				tex = Paths.getSparrowAtlas('characters/Gema3d');
				frames = tex;
				animation.addByPrefix('idle', 'getema_idle', 24, false);
				animation.addByPrefix('singUP', 'getema_up', 24);
				animation.addByPrefix('singRIGHT', 'getema_left', 24);
				animation.addByPrefix('singDOWN', 'getema_down', 24);
				animation.addByPrefix('singLEFT', 'getema_right', 24);
				updateHitbox();

				characterData.offsetY = 930;
				//characterData.offsetX = -90;

				playAnim('idle');

			case 'papaDasArmas':
				tex = Paths.getSparrowAtlas('characters/PAPA_DAS_ARMAS');
				frames = tex;
				animation.addByPrefix('idle', 'PDA_idle', 24, false);
				animation.addByPrefix('singUP', 'PDA_up', 24);
				animation.addByPrefix('singRIGHT', 'PDA_right', 24);
				animation.addByPrefix('singDOWN', 'PDA_down', 24);
				animation.addByPrefix('singLEFT', 'PDA_left', 24);
				animation.addByPrefix('shoot', 'PDA_gunshoot', 24);
				updateHitbox();
				characterData.offsetY = 720;
				characterData.offsetX = -260;
				characterData.camOffsetY = 130;
				characterData.camOffsetX = 200;

				playAnim('idle');

			case 'chicken':
				tex = Paths.getSparrowAtlas('characters/chickenRESHAPED');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;

				playAnim('idle');

				characterData.camOffsetX = -135;
				characterData.camOffsetY = -30;
				
			case 'chicken-player':
				tex = Paths.getSparrowAtlas('characters/chicken2');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singUPmiss', 'up', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'down', 24, false);
				animation.addByPrefix('singLEFTmiss', 'left', 24, false);
				// die >:]
				animation.addByIndices('death', 'idle', [10], "", 0, false);
				

				characterData.offsetY = -435;
				characterData.offsetX = -80;
				characterData.camOffsetY = 300;

				playAnim('idle');

			case 'chicken-player-pixel':
				tex = Paths.getSparrowAtlas('characters/chickenRESHAPED');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singUPmiss', 'up', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'down', 24, false);
				animation.addByPrefix('singLEFTmiss', 'left', 24, false);
				// die >:]
				animation.addByIndices('death', 'idle', [10], "", 0, false);
				
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;

				playAnim('idle');

				characterData.camOffsetX = -135;
				characterData.camOffsetY = -230;

			case 'presidente':
				tex = Paths.getSparrowAtlas('characters/presidente');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				
				setGraphicSize(Std.int(width * 2.2));
				updateHitbox();
				antialiasing = false;

				playAnim('idle');

			case 'daianedossantos':
				tex = Paths.getSparrowAtlas('characters/daianedosmantos');
				frames = tex;
				animation.addByPrefix('idle', 'idle dos santos', 24, true);
				animation.addByPrefix('singUP', 'up dos santos', 24);
				animation.addByPrefix('singRIGHT', 'left', 24);
				animation.addByPrefix('singDOWN', 'down dos santos', 24);
				animation.addByPrefix('singLEFT', 'right dos santos', 24);
				
				// dont ask why
				scale.set(1, 1);
				updateHitbox();

				playAnim('idle');
			default:
				// set up animations if they aren't already

				// fyi if you're reading this this isn't meant to be well made, it's kind of an afterthought I wanted to mess with and
				// I'm probably not gonna clean it up and make it an actual feature of the engine I just wanted to play other people's mods but not add their files to
				// the engine because that'd be stealing assets
				var fileNew = curCharacter + 'Anims';
				if (OpenFlAssets.exists(Paths.offsetTxt(fileNew)))
				{
					var characterAnims:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(fileNew));
					var characterName:String = characterAnims[0].trim();
					frames = Paths.getSparrowAtlas('characters/$characterName');
					for (i in 1...characterAnims.length)
					{
						var getterArray:Array<Array<String>> = CoolUtil.getAnimsFromTxt(Paths.offsetTxt(fileNew));
						animation.addByPrefix(getterArray[i][0], getterArray[i][1].trim(), 24, false);
					}
				}
				else
					return setCharacter(x, y, 'bf');
		}

		// set up offsets cus why not
		if (OpenFlAssets.exists(Paths.offsetTxt(curCharacter + 'Offsets')))
		{
			var characterOffsets:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(curCharacter + 'Offsets'));
			for (i in 0...characterOffsets.length)
			{
				var getterArray:Array<Array<String>> = CoolUtil.getOffsetsFromTxt(Paths.offsetTxt(curCharacter + 'Offsets'));
				addOffset(getterArray[i][0], Std.parseInt(getterArray[i][1]), Std.parseInt(getterArray[i][2]));
			}
		}

		dance();

		if (isPlayer) // fuck you ninjamuffin lmao
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
				flipLeftRight();
			//
		}
		else if (curCharacter.startsWith('bf'))
			flipLeftRight();

		if (adjustPos)
		{
			x += characterData.offsetX;
			trace('character ${curCharacter} scale ${scale.y}');
			y += (characterData.offsetY - (frameHeight * scale.y));
		}

		this.x = x;
		this.y = y;
		
		this.startX = x;
		
		return this;
	}

	function flipLeftRight():Void
	{
		// get the old right sprite
		var oldRight = animation.getByName('singRIGHT').frames;

		// set the right to the left
		animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;

		// set the left to the old right
		animation.getByName('singLEFT').frames = oldRight;

		// insert ninjamuffin screaming I think idk I'm lazy as hell

		if (animation.getByName('singRIGHTmiss') != null)
		{
			var oldMiss = animation.getByName('singRIGHTmiss').frames;
			animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
			animation.getByName('singLEFTmiss').frames = oldMiss;
		}
	}

	private var elapsedtime:Float = 0;
	override function update(elapsed:Float)
	{
		elapsedtime += (elapsed * Math.PI);

		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		var curCharSimplified:String = simplifyCharacter();
		switch (curCharSimplified)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
				if ((animation.curAnim.name.startsWith('sad')) && (animation.curAnim.finished))
					playAnim('danceLeft');
		}

		// Post idle animation (think Week 4 and how the player and mom's hair continues to sway after their idle animations are done!)
		if (animation.curAnim.finished && animation.curAnim.name == 'idle')
		{
			// We look for an animation called 'idlePost' to switch to
			if (animation.getByName('idlePost') != null)
				// (( WE DON'T USE 'PLAYANIM' BECAUSE WE WANT TO FEED OFF OF THE IDLE OFFSETS! ))
				animation.play('idlePost', true, false, 0);
		}

		super.update(elapsed);

		switch(curCharacter.toLowerCase())
		{
			case 'tibba': // ta potente
				x = -1025 - (Math.cos(elapsedtime / 2)) * 350;
				y = 100 - (Math.sin(elapsedtime)) * 50;
			case 'presidente':
				y = 120 - Math.sin(elapsedtime) * 50;
		}
	}

	/**
	 * FOR GF DANCING SHIT
	 */
	private var danced:Bool = false;
	public function dance(?forced:Bool = false)
	{
		//if (!debugMode && !specialAnim)
		if (!specialAnim)
		{
			var curCharSimplified:String = simplifyCharacter();
			switch (curCharSimplified)
			{
				case 'gf':
					if ((!animation.curAnim.name.startsWith('hair')) && (!animation.curAnim.name.startsWith('sad')))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
				case 'mugen' | 'gemafunkin':
					if(FlxG.random.bool(10))
						playAnim('hey', forced);
					else
						playAnim('idle', forced);
						
				case 'mc': // mc vv
					// Left/right dancing, think Skid & Pump
					if (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null)
					{
						danced = !danced;
						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
				
				default:
					playAnim('idle', forced);
			}
		}
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) != null)
			super.playAnim(AnimName, Force, Reversed, Frame);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
				danced = true;
			else if (AnimName == 'singRIGHT')
				danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
				danced = !danced;
		}
		
		if(!isNativelyPlayer && isPlayer) {
			this.color = (AnimName.endsWith('miss')) ? FlxColor.BLUE : FlxColor.WHITE;
		}

		//if(curCharacter == 'gemafunkin-player')
		//	this.color = (AnimName == 'dodge') ? FlxColor.CYAN : FlxColor.WHITE;
	}

	public function simplifyCharacter():String
	{
		var base = curCharacter;

		if (base.contains('-'))
			base = base.substring(0, base.indexOf('-'));
		return base;
	}
}
