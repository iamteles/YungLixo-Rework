package meta.state;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import meta.state.TitleState;
import meta.MusicBeat.MusicBeatState;

class FlashingState extends MusicBeatState
{
  var avisoAppear:Bool = false;
  var selectedSomethin:Bool = false;
  var avisado:FlxSprite;
  var warning:String = 'vs raphalitos melhor mod'; // heheheheh
  var daText:FlxText;

  override function create()
  {
    super.create();

    avisado = new FlxSprite();
    avisado.loadGraphic(Paths.image('suamae/aviso'));
    avisado.scale.set(2.9,2.9);
    avisado.updateHitbox();
    avisado.screenCenter();
    avisado.alpha = 0;
    add(avisado);

    warning = 'AVISO\n\nEsse mod contém luzes fortes\nCaso você seja sensível a elas desative-as nas Opções\n\nVocê foi avisado.';

    daText = new FlxText(40, 40, 1180, warning, 36);
		daText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER);
		daText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		daText.antialiasing = true;
		add(daText);

    daText.x = Math.floor((FlxG.width / 2) - (daText.width / 2));
    daText.y = Math.floor((FlxG.height / 2) - (daText.height / 2));
  }

  override function update(elapsed:Float)
  {
    if(controls.ACCEPT || controls.BACK)
      gotoGame();

    if(avisoAppear)
      avisado.alpha += 1.1 * elapsed;
  }

  function gotoGame()
  {
    if(!selectedSomethin)
    {
      selectedSomethin = true;
      avisoAppear = true;
      FlxG.sound.play(Paths.sound('cancelMenu'));
      FlxG.camera.fade(FlxColor.BLACK, 1.42, false, function()
      {
        Main.switchState(this, new TitleState());
      });
    }
  }
}
