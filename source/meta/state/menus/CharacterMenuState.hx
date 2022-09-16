package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;
import gameObjects.Character;

using StringTools;

/**
	this is the character menu state
	:sunglasses:
**/
class CharacterMenuState extends MusicBeatState
{
	public var elapsedtime:Float = 0;

	var characters:Array<String> = ['boyfriend', 'gemafunkin', 'chicken'];
	static var curSelected:Int = 0;
	var selectedSomethin:Bool = false;

	var bg:FlxSprite; // the background has been separated for more control
	var menuChar:FlxSprite;
	var theArrow:FlxText;
	
	// we just need one public static var for this
	public static var boyfriendModifier:String = '';
	var boyfriendPos:Array<Dynamic> = [-370, 20];
	var boyfriendScale:Float = 0.6;
	
	var chickenModifier:String = '';
	var chickenPos:Array<Dynamic> = [230,-310]; //-300
	var chickenScale:Float = 0.8;
	
	var boyfriend:Character;
	var gemafunkin:Character;
	var chicken:Character;

	// the create 'state'
	override function create()
	{
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		// uh
		persistentUpdate = persistentDraw = true;

		// background
		var backdrop:FlxSprite = new FlxBackdrop(Paths.image('menus/ylr/tileLoop'), 8, 8, true, true, 1, 1);
		backdrop.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		backdrop.screenCenter();
		add(backdrop);

		var gradient:FlxSprite = new FlxSprite();
		gradient.loadGraphic(Paths.image('menus/ylr/gradient'));
		gradient.scrollFactor.set();
		gradient.screenCenter();
		gradient.antialiasing = true;
		add(gradient);

		// i hate you pixel boyfriend
		if(boyfriendModifier == '-pixel') {
			boyfriendPos = [-180,175];
			boyfriendScale = chickenScale = 3.6; // yeah
			chickenModifier = boyfriendModifier;
			chickenPos = [365, 200];
		}
		if(boyfriendModifier == '-reshaped')
			boyfriendPos[0] += 30;

		boyfriend = new Character();
		boyfriend.setCharacter(0, 0, 'bf' + boyfriendModifier);
		boyfriend.scale.set(boyfriendScale, boyfriendScale);
		boyfriend.updateHitbox();
		boyfriend.screenCenter();
		boyfriend.x += boyfriendPos[0];
		boyfriend.y += boyfriendPos[1];
		//boyfriend.flipX = true;
		add(boyfriend);
		if(boyfriendModifier == '-reshaped') boyfriend.y += -25;

		// i like you gemafunkin
		gemafunkin = new Character();
		gemafunkin.setCharacter(0, 0, 'gemafunkin-select');
		gemafunkin.scale.set(0.6,0.6);
		gemafunkin.screenCenter();
		gemafunkin.x = Math.floor((FlxG.width / 2) - (gemafunkin.width / 2));
		gemafunkin.x += 10;
		add(gemafunkin);

		chicken = new Character();
		chicken.setCharacter(0, 0, 'chicken-player' + chickenModifier);
		chicken.scale.set(chickenScale,chickenScale);
		chicken.updateHitbox();
		chicken.screenCenter();
		chicken.x += chickenPos[0];
		chicken.y += chickenPos[1];
		add(chicken);

		boyfriend.playAnim('idle', true);
		gemafunkin.playAnim('idle', true);
		chicken.playAnim('idle', true);

		//updateSelection();

		// from the base game lol

		var versionShit:FlxText = new FlxText(10, 48, 0, "CHOOSE YOUR CHARACTER", 48);
		versionShit.scrollFactor.set();
		versionShit.setFormat("splatter.otf", 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		versionShit.x = Math.floor((FlxG.width / 2) - (versionShit.width / 2));

		theArrow = new FlxText(500, 600, 0, ">", 48);
		theArrow.angle = -90;
		theArrow.scrollFactor.set();
		theArrow.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//theArrow.x = Math.floor((FlxG.width / 2) - (theArrow.width / 2));
		add(theArrow);

		var idleTimer:FlxTimer = new FlxTimer().start(1, function(timer:FlxTimer) {
			playIdle();
		}, 0);

		updateSelection();
	}

	override function update(elapsed:Float)
	{
		if(!selectedSomethin)
		{
			if(controls.UI_LEFT_P)
				updateSelection(-1);
			if(controls.UI_RIGHT_P)
				updateSelection(1);


			if (controls.BACK)
			{
				selectedSomethin = true;
				Main.switchState(this, new FreeplayState());
			}

			if(controls.ACCEPT)
			{
				switch(characters[curSelected])
				{
					case 'boyfriend':
						selectChar(boyfriend);

					case 'gemafunkin':
						selectChar(gemafunkin);
					
					case 'chicken':
						selectChar(chicken);
				}
			}
		}

		boyfriend.color  = (characters[curSelected] == 'boyfriend') ? FlxColor.WHITE : FlxColor.fromRGB(120,120,120);
		gemafunkin.color = (characters[curSelected] == 'gemafunkin') ? FlxColor.WHITE : FlxColor.fromRGB(120,120,120);
		chicken.color = (characters[curSelected] == 'chicken') ? FlxColor.WHITE : FlxColor.fromRGB(120,120,120);

		if(FlxG.keys.justPressed.CONTROL)
			trace('the arrow X is: ${Std.int(theArrow.x)}');

		super.update(elapsed);
		
		// posição da seta
		elapsedtime += (elapsed * Math.PI);
		theArrow.y = 600 - (Math.sin(elapsedtime * 3)) * 20;
		var raphalitos:Float = 0;
		switch(characters[curSelected])
		{
			case 'boyfriend':
				raphalitos = 350;
			case 'gemafunkin':
				raphalitos = ((FlxG.width / 2) - (theArrow.width / 2));
			case 'chicken':
				raphalitos = FlxG.width - theArrow.width - 350;
		}
		theArrow.x = FlxMath.lerp(theArrow.x, raphalitos, 0.2);
	}

	private function playIdle()
	{
		if(!selectedSomethin)
		{
			boyfriend.playAnim('idle', true);
			gemafunkin.playAnim('idle', true);
			chicken.playAnim('idle', true);
		}
	}

	private function updateSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.85);
		curSelected += change;

		if (curSelected < 0)
			curSelected = characters.length - 1;
		if (curSelected >= characters.length)
			curSelected = 0;

		
		/* switch (curSelected)
		{
			case 0:
				FlxTween.tween(theArrow, {x: 235}, 0.1, {ease: FlxEase.expoOut});
			case 1:
				FlxTween.tween(theArrow, {x: 635}, 0.1, {ease: FlxEase.expoOut});
			case 2:
				FlxTween.tween(theArrow, {x: 970}, 0.1, {ease: FlxEase.expoOut});
		} */
	}

	private function selectChar(who:Character)
	{
		/*
		if(who == chicken && chickenModifier != "-pixel")
			who.playAnim((who.animation.getByName('hey') == null) ? 'singDOWN' : 'hey', true);
		else
			who.playAnim((who.animation.getByName('hey') == null) ? 'singUP' : 'hey', true);
		*/
		// im lazy, sorry
		CoolUtil.flashScreen(FlxG.camera, 1);

		selectedSomethin = true;
		
		if(who == boyfriend)
			PlayState.changedCharacter = 0;
		if(who == gemafunkin)
			PlayState.changedCharacter = 1;
		if(who == chicken)
			PlayState.changedCharacter = ((chickenModifier != "-pixel") ? 2 : 3);

		FlxG.sound.play(Paths.sound('confirmMenu'));
		var idleTimer:FlxTimer = new FlxTimer().start(1, function(timer:FlxTimer) {
			if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
			Main.switchState(this, new PlayState());
		}, 1);
	}
}
