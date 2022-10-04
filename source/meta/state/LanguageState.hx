package meta.state;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import meta.state.TitleState;
import meta.MusicBeat.MusicBeatState;

class LanguageState extends MusicBeatState
{
	var selectedSomethin:Bool = false;
	var curSelected:Int = 0;
	var options:Array<String> = ["pt-br", "english"];
	var daButtons:Array<FlxText> = [];

	override function create()
	{
		super.create();
		
		for(i in 0...options.length)
		{
			var daText:FlxText = new FlxText(40, 40, 1180, options[i].toUpperCase(), 36);
			daText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER);
			daText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
			daText.antialiasing = true;

			daText.x = Math.floor((FlxG.width / 2) - (daText.width / 2));
			daText.y = Math.floor((FlxG.height / 2) - (daText.height / 2));
			
			daText.y += (i == 0) ? 15 : -15;
			
			daText.ID = i;
			daButtons.push(daText);
			add(daText);
		}
	}

	override function update(elapsed:Float)
	{
		if(!selectedSomethin)
		{
			if(controls.ACCEPT)
				gotoGame();
			
			if(controls.UI_UP_P || controls.UI_DOWN_P)
				changeSelection();
		}
		
		for(i in daButtons)
			i.alpha = (i.ID == curSelected) ? 1 : 0.7;
	}

	function gotoGame()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('cancelMenu'));
			
		FlxG.save.data.firstTime = false;
		Init.trueSettings.set('Language', options[curSelected]);
		Init.saveSettings();
		
		Main.switchState(this, new FlashingState());
	}
	
	function changeSelection()
	{
		curSelected++;
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		if(curSelected < 0)
		   curSelected = options.length - 1;
		if(curSelected > options.length - 1)
		   curSelected = 0;
	}
}
