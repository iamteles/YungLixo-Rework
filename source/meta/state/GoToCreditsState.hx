package meta.state;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;
import gameObjects.userInterface.CreditsIcon;
import lime.utils.Assets;
import meta.state.menus.*;
import meta.MusicBeat.MusicBeatState;
import meta.CoolUtil;
import meta.data.*;
import meta.data.Song.SwagSong;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import openfl.media.Sound;
import sys.FileSystem;
import sys.thread.Thread;

class GoToCreditsState extends MusicBeatState
{
  var selectedSomethin:Bool = false;

  var warning:FlxSprite;
  var warnImages:Array<String> = [
    'unknown', // eu podia fazer isso de um jeito melhor
    'unknown', // mas preguiça é foda
    'unknown',
    'unknown',
    'unknown',
    'vagabundo-1',
    '580_Sem_Titulo_20220823132055'
  ];

  override function create()
  {
    super.create();

    #if DISCORD_RPC
		Discord.changePresence('NOT THE CREDITS SCREEN', 'Freeplay Menu');
		#end

    // setting up transitions
    transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

    warning = new FlxSprite();
    warning.loadGraphic(Paths.image('credits/vaiveroscreditos/' + CoolUtil.randomString(warnImages)));
    warning.setGraphicSize(Std.int(warning.width * 1.5));
    warning.screenCenter();
    add(warning);
  }

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    if(!selectedSomethin)
		{
			if (controls.BACK || controls.ACCEPT)
			{
        selectedSomethin = true;
        FlxG.sound.play(Paths.sound('scrollMenu'));
        Main.switchState(this, new FreeplayState());
			}
		}
  }
}
