package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
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
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class CharacterMenuStateMineirinho extends MusicBeatState
{
	var elapsedtime:Float = 0;

	static var curSelected:Float = 0;
	static var arrowPos:Float = 640;// - (theArrow.width / 2));
	var selectedSomethin:Bool = false;

	var bg:FlxSprite; // the background has been separated for more control
	var menuChar:FlxSprite;
	var theArrow:FlxSprite;
	
	public static var boyfriendModifier:String = '';
	var boyfriend:Character;
	var gemafunkin:Character;

	// the create 'state'
	override function create()
	{
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		//ForeverTools.resetMenuMusic();

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

		// create the menu items themselves

		boyfriend = new Character();
		boyfriend.setCharacter(0, 0, 'bf' + boyfriendModifier);
		boyfriend.scale.set(0.6,0.6);
		boyfriend.screenCenter();
		boyfriend.x -= 180;
		boyfriend.y += 120;
		boyfriend.flipX = true;
		add(boyfriend);
		if(boyfriendModifier == '-reshaped') boyfriend.y += -25;
		
		gemafunkin = new Character();
		gemafunkin.setCharacter(0, 0, 'gemafunkin-select');
		gemafunkin.scale.set(0.6,0.6);
		gemafunkin.screenCenter();
		gemafunkin.x += 200;
		add(gemafunkin);
		
		boyfriend.playAnim('idle', true);
		gemafunkin.playAnim('idle', true);

		//updateSelection();

		// from the base game lol

		var versionShit:FlxText = new FlxText(10, 48, 0, "CHOOSE YOUR CHARACTER", 48);
		versionShit.scrollFactor.set();
		//versionShit.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.setFormat("comicBOLD.ttf", 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		versionShit.x = Math.floor((FlxG.width / 2) - (versionShit.width / 2));
		
		/*
		theArrow = new FlxText(500, 600, 0, ">", 48);
		theArrow.angle = -90;
		theArrow.scrollFactor.set();
		theArrow.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		theArrow.screenCenter(X);
		add(theArrow);
		*/
		theArrow = new FlxSprite(500,600).loadGraphic(Paths.image('menus/ylr/mineirinho arrow'));
		theArrow.angle = -90;
		theArrow.scale.set(1.2,1.2);
		theArrow.scrollFactor.set();
		//theArrow.screenCenter(X);
		add(theArrow);
		
		var idleTimer:FlxTimer = new FlxTimer().start(1, function(timer:FlxTimer) {
			playIdle();
		}, 0);
	}

	override function update(elapsed:Float)
	{
		elapsedtime += (elapsed * Math.PI);
		
		theArrow.y = 620 - (Math.sin(elapsedtime * 3)) * 20;
		theArrow.x = arrowPos;
		
		if(!selectedSomethin)
		{
			if(controls.UI_LEFT && theArrow.x >= 329)
				arrowPos -= 300 * elapsed;
			if(controls.UI_RIGHT && theArrow.x <= 884)
				arrowPos += 300 * elapsed;
		
			if (controls.BACK)
			{
				selectedSomethin = true;
				Main.switchState(this, new FreeplayState());
			}
		
			if(controls.ACCEPT)
			{
				if(theArrow.x <= 535)
					selectChar(boyfriend);
			
				if(theArrow.x >= 747)
					selectChar(gemafunkin);
			}
		}
		
		boyfriend.color = (theArrow.x <= 535) ? FlxColor.WHITE : FlxColor.fromRGB(120,120,120);
		gemafunkin.color = (theArrow.x >= 747) ? FlxColor.WHITE : FlxColor.fromRGB(120,120,120);
		
		if(FlxG.keys.justPressed.CONTROL)
			trace('the arrow X is: ${Std.int(theArrow.x)}');
			
		super.update(elapsed);
	}
	
	private function playIdle()
	{
		if(boyfriend.animation.curAnim.name != 'hey')
			boyfriend.playAnim('idle', true);
		if(gemafunkin.animation.curAnim.name != 'hey')
			gemafunkin.playAnim('idle', true);
	}
	
	private function selectChar(who:Character)
	{
		who.playAnim('hey', true);
		selectedSomethin = true;
			
		if(who == boyfriend)
			PlayState.changedCharacter = 0;
		else
			PlayState.changedCharacter = 1;
		
		FlxG.sound.play(Paths.sound('confirmMenu'));
		var idleTimer:FlxTimer = new FlxTimer().start(1, function(timer:FlxTimer) {
			if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
			Main.switchState(this, new PlayState());
		}, 1);
	}
}