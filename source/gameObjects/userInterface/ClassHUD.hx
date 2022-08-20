package gameObjects.userInterface;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.Timings;
import meta.state.PlayState;

using StringTools;

class ClassHUD extends FlxTypedGroup<FlxBasic>
{
	// set up variables and stuff here
	var scoreBar:FlxText;
	var scoreLast:Float = -1;

	// fnf mods
	var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop';


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var SONG = PlayState.SONG;

	public var iconP1:HealthIcon;
	public static var iconP2:HealthIcon;
	public static var iconP3:HealthIcon;

	private var stupidHealth:Float = 0;

	private var timingsMap:Map<String, FlxText> = [];

	var healthBarEmptyColor:FlxColor = 0xFFFF0000;
	var healthBarFilledColor:FlxColor = 0xFF66FF33;

	public static var songAuthor:FlxSprite;

	var is3Player:Bool = false;

	// eep
	public function new()
	{
		// call the initializations and stuffs
		super();

		
		// le healthbar setup
		var barY = FlxG.height * 0.875;
		if (Init.trueSettings.get('Downscroll'))
			barY = 64;

		var color: Array<Int>;
		var colorTable = [
			"gemaplys" => [0, 165, 186],
			"yunglixo" => [255, 65, 4],
			"vito" => [33, 32, 40],
			"bf" => [49, 176, 209],
			"bf-psych" => [49, 176, 209],
		];

		if(CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()) == "operational-system")
		{
			var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/pintows/overlay'));
			bg.antialiasing = true;
			add(bg);
		}
		
		color = colorTable[SONG.player1];
		if (color != null)
			healthBarFilledColor.setRGB(color[0], color[1], color[2], 255);
		
		color = colorTable[SONG.player2];
		if (color != null)
			healthBarEmptyColor.setRGB(color[0], color[1], color[2], 255);

		healthBarBG = new FlxSprite(0, barY).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBar', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8));
		healthBar.scrollFactor.set();
		if(!Init.trueSettings.get('Colored Healthbars') || CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()) == "collision")
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		else
			healthBar.createGradientBar([healthBarFilledColor, healthBarEmptyColor, healthBarEmptyColor], [healthBarFilledColor, healthBarFilledColor, healthBarEmptyColor]);
		// healthBar
		add(healthBar);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);

		if(CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()) == "killer-tibba")
		{
			iconP3 = new HealthIcon("tibba", false);
			iconP3.y = healthBar.y - (iconP2.height / 2);
			iconP3.alpha = 0.00001;
			is3Player = true;
			add(iconP1);
			add(iconP2);
			add(iconP3);
		}
		else if(CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()) != "collision")
		{
			add(iconP1);
			add(iconP2);
			is3Player = false;
		}
		else
		{
			var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/gema/vida'));
			bg.antialiasing = true;
			add(bg);
			is3Player = false;
		}



		songAuthor = new FlxSprite(-700, -130).loadGraphic(Paths.image('cards/' + CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()) + '-' + CoolUtil.difficultyFromNumber(PlayState.storyDifficulty).toLowerCase()));
		songAuthor.setGraphicSize(Std.int(songAuthor.width * 0.5));
		songAuthor.scrollFactor.set();
		add(songAuthor);

		scoreBar = new FlxText(FlxG.width / 2, Math.floor(healthBarBG.y + 40), 0, scoreDisplay);
		scoreBar.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE);
		scoreBar.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		updateScoreText();
		// scoreBar.scrollFactor.set();
		scoreBar.antialiasing = true;
		add(scoreBar);


		// counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			var judgementNameArray:Array<String> = [];
			for (i in Timings.judgementsMap.keys())
				judgementNameArray.insert(Timings.judgementsMap.get(i)[0], i);
			judgementNameArray.sort(sortByShit);
			for (i in 0...judgementNameArray.length)
			{
				var textAsset:FlxText = new FlxText(5
					+ (!left ? (FlxG.width - 10) : 0),
					(FlxG.height / 2)
					- (counterTextSize * (judgementNameArray.length / 2))
					+ (i * counterTextSize), 0, '', counterTextSize);
				if (!left)
					textAsset.x -= textAsset.text.length * counterTextSize;
				textAsset.setFormat(Paths.font("vcr.ttf"), counterTextSize, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				textAsset.scrollFactor.set();
				timingsMap.set(judgementNameArray[i], textAsset);
				add(textAsset);
			}
		}
		updateScoreText();
	}

	var counterTextSize:Int = 18;

	function sortByShit(Obj1:String, Obj2:String):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Timings.judgementsMap.get(Obj1)[0], Timings.judgementsMap.get(Obj2)[0]);

	var left = (Init.trueSettings.get('Counter') == 'Left');

	override public function update(elapsed:Float)
	{
		// pain, this is like the 7th attempt
		healthBar.percent = (PlayState.health * 50);

		var iconLerp = 0.85;
		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.initialWidth, iconP1.width, iconLerp)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.initialWidth, iconP2.width, iconLerp)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if(is3Player && iconP3.alpha > 0.5)
		{
			iconP2.y = iconP1.y + 23;
			iconP3.x = iconP2.x - 45;
			iconP3.y = iconP2.y - 45;

			iconP3.scale.set(iconP2.scale.x, iconP2.scale.y);
			iconP3.updateHitbox();

			if (healthBar.percent > 80)
				iconP3.animation.curAnim.curFrame = 1;
			else
				iconP3.animation.curAnim.curFrame = 0;
			
		} 
			

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;
	}

	private final divider:String = " • ";

	public function updateScoreText()
	{
		var importSongScore = PlayState.songScore;
		var importPlayStateCombo = PlayState.combo;
		var importMisses = PlayState.misses;
		scoreBar.text = 'Score: $importSongScore';
		// testing purposes
		var displayAccuracy:Bool = Init.trueSettings.get('Display Accuracy');
		if (displayAccuracy)
		{
			scoreBar.text += divider + 'Accuracy: ' + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%';
			scoreBar.text += divider + 'Combo Breaks: ' + Std.string(PlayState.misses);
			//scoreBar.text += divider + 'Rank: ' + Std.string(Timings.returnScoreRating().toUpperCase());
		}
		scoreBar.text += '\n';
		scoreBar.x = Math.floor((FlxG.width / 2) - (scoreBar.width / 2));

		// update counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			for (i in timingsMap.keys())
			{
				timingsMap[i].text = '${(i.charAt(0).toUpperCase() + i.substring(1, i.length))}: ${Timings.gottenJudgements.get(i)}';
				timingsMap[i].x = (5 + (!left ? (FlxG.width - 10) : 0) - (!left ? (6 * counterTextSize) : 0));
			}
		}

		// update playstate
		PlayState.detailsSub = scoreBar.text;
		PlayState.updateRPC(false);
	}

	public function beatHit()
	{
		if (!Init.trueSettings.get('Reduced Movements'))
		{
			iconP1.setGraphicSize(Std.int(iconP1.width + 30));
			iconP2.setGraphicSize(Std.int(iconP2.width + 30));

			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}
		//
	}
}
