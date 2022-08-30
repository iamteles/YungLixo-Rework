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
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MainMenuState extends MusicBeatState
{
	public var elapsedtime:Float = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	static var curSelected:Float = 0;

	var bg:FlxSprite; // the background has been separated for more control
	var menuChar:FlxSprite;
	var randomChar:Int = FlxG.random.int(1, 1);
	var camFollow:FlxObject;

	var optionShit:Array<String> = ['story', 'freeplay', 'credits', 'options'];
	var canSnap:Array<Float> = [];

	// the create 'state'
	override function create()
	{
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if DISCORD_RPC
		Discord.changePresence('MENU SCREEN', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		// background
		var backdrop:FlxSprite = new FlxBackdrop(Paths.image('menus/ylr/tileLoop'), 8, 8, true, true, 1, 1);
		backdrop.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		backdrop.screenCenter();
		add(backdrop);
		
		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/ylr/mainMenu'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		menuChar = new FlxSprite(0, 0);
		menuChar.loadGraphic(Paths.image('menus/ylr/character/menuchar_' + randomChar));
		menuChar.screenCenter();
		add(menuChar);

		// add the menu items
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		// create the menu items themselves

		// loop through the menu options
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(700, 80 + (i * 150));
			menuItem.loadGraphic(Paths.image('menus/ylr/buttons/' + optionShit[i].toLowerCase()));
			canSnap[i] = -1;
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.updateHitbox();

			/*
				FlxTween.tween(menuItem, {alpha: 1, x: ((FlxG.width / 2) - (menuItem.width / 2))}, 0.35, {
					ease: FlxEase.smootherStepInOut,
					onComplete: function(tween:FlxTween)
					{
						canSnap[i] = 0;
					}
			});*/
		}

		// set the camera to actually follow the camera object that was created before
		var camLerp = Main.framerateAdjust(0.10);
		FlxG.camera.follow(camFollow, null, camLerp);

		updateSelection();

		// from the base game lol

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Forever Engine v" + Main.gameVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		//
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);
		elapsedtime += (elapsed * Math.PI);
		
		//if(!selectedSomethin) {
			menuChar.x = -50 - (Math.cos(elapsedtime / 4)) * 20;
			menuChar.y = 50 - (Math.sin(elapsedtime / 2)) * 20;
		//}

		var up = controls.UI_UP;
		var down = controls.UI_DOWN;
		var up_p = controls.UI_UP_P;
		var down_p = controls.UI_DOWN_P;
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if ((controlArray.contains(true)) && (!selectedSomethin))
		{
			for (i in 0...controlArray.length)
			{
				// here we check which keys are pressed
				if (controlArray[i] == true)
				{
					// if single press
					if (i > 1)
					{
						// up is 2 and down is 3
						// paaaaaiiiiiiinnnnn
						if (i == 2)
							curSelected--;
						else if (i == 3)
							curSelected++;

						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					/* idk something about it isn't working yet I'll rewrite it later
						else
						{
							// paaaaaaaiiiiiiiinnnn
							var curDir:Int = 0;
							if (i == 0)
								curDir = -1;
							else if (i == 1)
								curDir = 1;

							if (counterControl < 2)
								counterControl += 0.05;

							if (counterControl >= 1)
							{
								curSelected += (curDir * (counterControl / 24));
								if (curSelected % 1 == 0)
									FlxG.sound.play(Paths.sound('scrollMenu'));
							}
					}*/

					if (curSelected < 0)
						curSelected = optionShit.length - 1;
					else if (curSelected >= optionShit.length)
						curSelected = 0;
				}
				//
			}
		}
		else
		{
			// reset variables
			counterControl = 0;
		}

		if ((controls.ACCEPT) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {alpha: 0, x: FlxG.width * 2}, 0.7, {
						ease: FlxEase.quadIn,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						var daChoice:String = optionShit[Math.floor(curSelected)];

						switch (daChoice)
						{
							case 'story': // prevent game locking
								Main.switchState(this, new StoryMenuState());
							//case 'credits':
							//	Main.switchState(this, new CharacterMenuState());
							case 'freeplay' | 'credits':
								Main.switchState(this, new FreeplayState());
							case 'options':
								transIn = FlxTransitionableState.defaultTransIn;
								transOut = FlxTransitionableState.defaultTransOut;
								Main.switchState(this, new OptionsMenuState());
						}
					});
				}
			});
		}

		if (Math.floor(curSelected) != lastCurSelected)
			updateSelection();

		super.update(elapsed);
	}

	var lastCurSelected:Int = 0;

	private function updateSelection()
	{
		// reset all selections
		menuItems.forEach(function(spr:FlxSprite)
		{
			var theX:Float;
			var theColor:Int;
			
			theX = (spr.ID == curSelected) ? 550 : 700;
			theColor = (spr.ID == curSelected) ? FlxColor.WHITE : FlxColor.fromRGB(45,45,45);
			
			FlxTween.tween(spr, {x: theX}, 0.2, {ease: FlxEase.quadOut});
			spr.color = theColor;
		});

		// set the sprites and all of the current selection

		//if (menuItems.members[Math.floor(curSelected)].animation.curAnim.name == 'idle')
		//	menuItems.members[Math.floor(curSelected)].animation.play('selected');

		menuItems.members[Math.floor(curSelected)].updateHitbox();

		lastCurSelected = Math.floor(curSelected);
	}
}
