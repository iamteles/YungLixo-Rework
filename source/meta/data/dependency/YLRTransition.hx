package meta.data.dependency;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.Transition;
import flixel.addons.transition.TransitionData;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import meta.MusicBeat.MusicBeatSubState;

/**
 *
 * Transition overrides
 * @author Shadow_Mario_ and DiogoTV
 *
**/
class YLRTransition extends MusicBeatSubState
{
	public static var finishCallback:Void->Void;

	private var leTween:FlxTween = null;

	public static var nextCamera:FlxCamera;

	var isTransIn:Bool = false;
	var daBlack:FlxSprite;
	var squares:TransSquare;

	public function new(duration:Float, isTransIn:Bool)
	{
		super();

		this.isTransIn = isTransIn;
		var width:Int = Std.int(FlxG.width);
		var height:Int = Std.int(FlxG.height);

		daBlack = new FlxSprite().makeGraphic(width, height + 400, FlxColor.BLACK);
		daBlack.scrollFactor.set();
		//daBlack.x -= (width - FlxG.width) / 2;
		add(daBlack);
		daBlack.visible = false;
		
		squares = new TransSquare(isTransIn);
		squares.scrollFactor.set();
		add(squares);
		
		if (isTransIn)
		{
			daBlack.alpha = 1;
			FlxTween.tween(daBlack, {alpha: 0}, duration + 0.1, {
				onComplete: function(twn:FlxTween)
				{
					close();
				},
				ease: FlxEase.linear
			});
		}
		else
		{
			daBlack.alpha = 0;
			FlxTween.tween(daBlack, {alpha: 1}, duration + 0.1, {
				onComplete: function(twn:FlxTween)
				{
					if (finishCallback != null)
					{
						finishCallback();
					}
				},
				ease: FlxEase.linear
			});
		}
		
		trace('ya know, transIn is ${isTransIn}');
	}

	var camStarted:Bool = false;

	override function update(elapsed:Float)
	{
		var camList = FlxG.cameras.list;
		camera = camList[camList.length - 1];
		daBlack.cameras = [camera];
		squares.cameras = [camera];
		
		super.update(elapsed);
	}

	override function destroy()
	{
		if (leTween != null)
		{
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}