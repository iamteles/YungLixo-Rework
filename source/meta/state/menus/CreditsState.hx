package meta.state.menus;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
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
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.Song.SwagSong;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import openfl.media.Sound;
import sys.FileSystem;
import sys.thread.Thread;

using StringTools;

class CreditsState extends MusicBeatState
{
	//
	var elapsedtime:Float = 0;
	var iconSpin:Bool = FlxG.random.bool(10); // why is this funny to me
	var threadActive = true;

	// piadas mt fodas
	var leonIcon:String = 'Leon_zap_zap_icon_Normal_fifiufiufifuifufiu';
	var amandaImage:String = "https://media.discordapp.net/attachments/985245746989248512/1014663808037437480/152_Sem_Titulo_20220831193103.png";
	var julianoFrase:String = (FlxG.random.bool(50) ?
	"miranda se você esta vendo isso saiba que suas bolas irão explodir dia 13/04/23 as 14:32" :
	"Alessandra volta pra mim e deixa eu ver meus filhos");

	// team
	var daTeam:Array<Array<Dynamic>> = [];

	var theGroup:FlxText;
	static var curSelected:Int = 0;

	private var grpCharacters:FlxTypedGroup<Alphabet>;

	private var iconArray:Array<CreditsIcon> = [];

	private var bgTween:FlxTween;
	private var bg:FlxSprite;
	
	private var vaca:FlxSprite;
	
	private var socialmedia:FlxSprite;

	private var descBG:FlxSprite;
	private var desc:FlxText;

	override function create()
	{
		super.create();

		daTeam = [ // name, icon, color, description, link, 0 = twitter  1 = youtube  2 = discord (sla)
		["Antony",		 'antony', 		FlxColor.fromRGB(233,0,0), 		'Diretor, Artista de Background, Escritor dos diálogos\n"Sim um furry fez esse mod, tenha medo"',			"https://twitter.com/Rizzatti321", 0],
		["JulianoBeta",	 'juliano', 	FlxColor.fromRGB(13,33,70), 	'Diretor, Compositor e Charter\n"${julianoFrase}"', 														"https://www.youtube.com/channel/UCRDeljMur0lEz1nXhrFKE9A", 1],
		["teles",		 'teles', 		FlxColor.fromRGB(255,129,60), 	'Co-Diretora, Coder, Artista/Animadora e Compositora\n(Sprites do Chicken/Presidente e Cutscene da Big-Boy)\n"IT KEEPS HAPPENING"',	"https://twitter.com/itzteles_aa", 0],
		["Yupam Uzuink", 'yupam', 		FlxColor.fromRGB(0,208,255), 	'Co-Diretor, Compositor, Artista de Card\n"AGOOOBAGOOBAGOOOOBAGOBAGOOOOOOOOBAAAAAA"', 						"https://twitter.com/yupfoda", 0],
		// coders
		["DiogoTV",		 'diogo', 		FlxColor.fromRGB(225,228,240), 	'Coder e Artista/Animador\n(Sprites do Gemafunkin, Icon do Tibba, Portraits dos diálogos e Cutscene da Killer-Tibba)\n"Feliz Aniversário Ellysson"',"https://twitter.com/DiogoTVV", 0],
		// artistas
		["Amanda Burra", 'amanda', 		FlxColor.fromRGB(144,67,238), 	'Artista/Animadora\n"${amandaImage}"',																		"https://twitter.com/Burra_Amanda", 0],
		["Aqua",		 'aqua', 		FlxColor.fromRGB(221,223,245), 	'Artista/Animador\n(Aviso na Collision)\n"danilo"',															"https://twitter.com/AquaStrikr_", 0],
		["Baicon",		 'baicon', 		FlxColor.fromRGB(64,128,255), 	'Artista/Animador\n(Macaco do Roblox)\n"ZAPEEEE, ZAPEEEEEE"',												"https://twitter.com/Baiconzito_", 0],
		["Jacc",		 'Jacc', 		FlxColor.fromRGB(145,9,210), 	'Artista/Animador\n"não acredito que ele fez cover do gemamugen da coliseu kkkkkkkkkk"',					"https://twitter.com/JackGD9", 0],
		["Johnatan o Animado",'john',	FlxColor.fromRGB(111,164,254), 	'Artista/Animador\n(MC VV, Mineirinho)\n"O mineirinho fnf foi a melhor coisa que eu já fiz na minha vida inteira"',"https://www.youtube.com/channel/UC18MTVMygNjI2mJ2yRCDXAg", 1],
		["Julitolito",	 'julitolito', 	FlxColor.fromRGB(0,204,153), 	'Artista/Animador\n(Sprites do Gemaplys/Yunglixo, e Cutscene da Potency)\n"até os perfeitos podem errar"',	"https://twitter.com/oJulitolito", 0],
		["Lukii",		 'lukii', 		FlxColor.fromRGB(148,46,33), 	'Artista/Animador\n(Cards)\n"insert the funny here"', 														"https://www.youtube.com/channel/UCp9IuIceEjvYoP7_i8xOZCg", 1],
		["Leozito",		 'leozito', 	FlxColor.fromRGB(74,167,96), 	'Artista de Icone\n"EU NÃO AGUENTO MAIS FAZER ICON, ALGUÉM ME AJUDA"',  									"https://twitter.com/Leozitoplays1", 0],
		["Memoria",		 'memoria', 	FlxColor.fromRGB(132,75,28), 	'Artista de Background\n"Hey book remember that time I appeared in the credits of a fnf mod?"', 			"https://twitter.com/Toad00253255", 0],
		["Sunno",		 'sunny', 		FlxColor.fromRGB(208,208,208), 	'Artista/Animador\n"swag"',																					"https://twitter.com/sunnyIDontKnow", 0],
		["Tanuki",		 'tanuki', 		FlxColor.fromRGB(36,249,146), 	'Artista/Animador\n"eu odeio a furry fand"', 																"https://twitter.com/TanukiMiugraarg", 0],
		// composers
		["AnakimPlay",	 'anakim', 		FlxColor.fromRGB(70,101,201), 	'Compositor\n"como é que faz musica"', 																		"https://twitter.com/AnakimPlay", 0],
		["Silly",		 'silly', 		FlxColor.fromRGB(139,127,222), 	'Compositora\n"toma essa anakim"',																			"https://twitter.com/YungCorno", 0],
		["Nerdin",		 'nerdin', 		FlxColor.fromRGB(30,27,172), 	'Compositor da Música de Pause\n"Leon é gay"', 																"https://twitter.com/nerdimensional", 0],
		// charters
		["Leon",		 leonIcon,		FlxColor.fromRGB(238,39,102),	'Charter\n"sou bonito sou gostoso jogo bola e danço"',														"https://twitter.com/leonzapzap", 0],
		["Pietro",		 'pi3tr0', 		FlxColor.fromRGB(255,255,255), 	'Charter\n"nota dupla supremacy"',  																		"https://twitter.com/Pi3tr03", 0],
		// yung lixo v1 team
		["Lone",		 'lon', 		FlxColor.fromRGB(253,18,57), 	'Diretor, Artista/Animador e Coder do Vs YL v1', 														"https://twitter.com/Lonius_", 0],
		["BeastlyChip",	 'chip', 		FlxColor.fromRGB(226,149,255), 	'Compositor, Charter e Cutscene SFX do Vs YL v1\n"quero chuva, quero chuva, chuva venha, venha chuva"', "https://twitter.com/BeastlyChip", 0],
		["Senshi_Z",	 'senshi', 		FlxColor.fromRGB(97,255,116), 	'Charter do Vs YL v1\n"Charts"', 																		"https://twitter.com/Senshi_Z12", 0],
		["NxtVithor",	 'nxt', 		FlxColor.fromRGB(99,80,182), 	'Arte Externa e Suporte do Vs YL v1\n"QUEM ME PINGOU"',  												"https://twitter.com/NxtVithor", 0],
		["BeastlyYoshiNG",'yoshi', 		FlxColor.fromRGB(133,35,206), 	'Artista de Background do Vs YL v1\n"pega essa amen break e enfia no olho do cu"',						"https://twitter.com/yoshizitosNG", 0],
		// gemaplys
		["Gemaplys",	 'gemaplys', 	FlxColor.fromRGB(184,69,69), 	'é o gemaplys',  "https://www.youtube.com/c/GEMAPLYS", 1],
		];

		if(!FlxG.save.data.daiane)
			daTeam.push(["???", 'ue', FlxColor.fromRGB(44,44,44), 'não clica', "", 3]);
		else
			daTeam.push(["Daiane dos Santos", 'daiane', FlxColor.fromRGB(44,44,44), 'Daiane dos Santos', "https://youtu.be/95Yh-zqwzVU?t=925", 1]);

		#if DISCORD_RPC
		Discord.changePresence('CREDITS SCREEN', 'Main Menu');
		#end

		// LOAD CHARACTERS
		//bg = new FlxSprite().loadGraphic(Paths.image('menus/base/menuDesat'));
		//add(bg);
		bg = new FlxBackdrop(Paths.image('menus/ylr/tileLoopWhite'), 8, 8, true, true, 1, 1);
		bg.velocity.x = 10;
		bg.screenCenter();
		add(bg);
		
		var white:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
		white.scrollFactor.set();
		white.screenCenter();
		white.antialiasing = true;
		white.alpha = 0.25;
		add(white);
		
		var gradient:FlxSprite = new FlxSprite();
		gradient.loadGraphic(Paths.image('menus/ylr/gradient'));
		gradient.scrollFactor.set();
		gradient.screenCenter();
		gradient.antialiasing = true;
		add(gradient);
		
		// vaca medonha
		vaca = new FlxSprite(0, 3000).loadGraphic(Paths.image('backgrounds/polygons/VACA-MEDONHA'));
		vaca.x = ((FlxG.width / 2) - (vaca.width / 2));
		vaca.scale.set(0.8,0.8);
		vaca.updateHitbox();
		add(vaca);

		grpCharacters = new FlxTypedGroup<Alphabet>();
		add(grpCharacters);
		for (i in 0...daTeam.length)
		{
			var songText:Alphabet = new Alphabet(0, (50 * i) + 30, daTeam[i][0], true, false, 0.85);
			songText.isMenuItem = true;
			songText.disableX = true;
			songText.targetY = i;
			songText.ID = i;
			grpCharacters.add(songText);

			var icon:CreditsIcon = new CreditsIcon(daTeam[i][1]);
			icon.sprTracker = songText;
			icon.scale.set(0.85,0.85);
			icon.updateHitbox();

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			songText.x += 40;
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		descBG = new FlxSprite(0, 0).makeGraphic(1280, 720, 0xFF000000);
		descBG.alpha = 0.6;
		add(descBG);
		//descBG.y = 680;

		desc = new FlxText(40, 40, 1180, "I LOVE LEAN CHARLIE!!!", 32);
		desc.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		desc.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		desc.scrollFactor.set();
		desc.antialiasing = true;
		add(desc);

		theGroup = new FlxText(0, 40, 1180, "I LOVE LEAN CHARLIE!!!", 36);
		theGroup.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER);
		theGroup.setBorderStyle(OUTLINE, FlxColor.BLACK, 3); //1.5
		theGroup.bold = true;
		theGroup.scrollFactor.set();
		theGroup.antialiasing = true;
		add(theGroup);

		socialmedia = new FlxSprite(0,0);
		socialmedia.frames = Paths.getSparrowAtlas('credits/socialmedia');
		socialmedia.animation.addByIndices('meme', 'social', [0, 1, 2, 3], "", 0, false);
		socialmedia.animation.play('meme');
		socialmedia.scale.set(0.8,0.8);
		socialmedia.updateHitbox();
		add(socialmedia);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		//elapsedtime += (elapsed * Math.PI);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if(threadActive)
		{
			if (upP)
				changeSelection(-1);
			else if (downP)
				changeSelection(1);

			if (controls.BACK)
			{
				threadActive = false;
				Main.switchState(this, new MainMenuState());
			}

			if (accepted)
			{
				if(curSelected == 27 && !FlxG.save.data.daiane)
					loadSong();
				else
					CoolUtil.browserLoad(daTeam[curSelected][4]);
			}
		}

		//random chance lol
		if(iconSpin)
		{
			elapsedtime += (elapsed * Math.PI); // lag less? i guess

			for (i in 0...iconArray.length)
			{
				if(i % 2 == 1)
				{
					iconArray[i].offset.x = (Math.sin(elapsedtime)) * 25;
					iconArray[i].offset.y = (Math.cos(elapsedtime)) * 25;
					iconArray[i].angle = (Math.sin(elapsedtime)) * 30;
				}
				else
				{
					iconArray[i].offset.x = (Math.cos(elapsedtime)) * 25;
					iconArray[i].offset.y = (Math.sin(elapsedtime)) * 25;
					iconArray[i].angle = (Math.cos(elapsedtime)) * 30;
				}
			}
		}
		
		// spooky
		var isSpooky:Bool = (curSelected == 27);
		vaca.y = FlxMath.lerp(vaca.y, (isSpooky ? 200 : 4000), (isSpooky ? 0.00004 : 0.05));
		
		for(item in grpCharacters)
		{
			if(item.ID == curSelected)
				item.x = FlxMath.lerp(item.x, 100 + 20, 0.3);
			else if(item.ID == curSelected - 1 || item.ID == curSelected + 1)
				item.x = FlxMath.lerp(item.x, 50 + 20, 0.3);
			else
				item.x = FlxMath.lerp(item.x, 20, 0.3);
		}
	}

	private function loadSong()
	{
		var poop:String = Highscore.formatSong("kkkri", 0);

		PlayState.SONG = Song.loadFromJson(poop, "kkkri");
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.changedCharacter = 0;
		Main.switchState(this, new PlayState());
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = daTeam.length - 1;
		if (curSelected >= daTeam.length)
			curSelected = 0;

		// set up color stuffs
		if(bgTween != null) bgTween.cancel();
		bgTween = FlxTween.color(bg, 0.35, bg.color, daTeam[curSelected][2]);

		// song switching stuffs
		var bullShit:Int = 0;

		for (i in 0...iconArray.length) {
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpCharacters.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			item.color = FlxColor.fromRGB(155,155,155);

			if (item.targetY == 0)
			{
				item.alpha = 1;
				item.color = FlxColor.WHITE;
			}
		}

		desc.text = daTeam[curSelected][3];
		desc.x = Math.floor((FlxG.width / 2) - (desc.width / 2));
		desc.y = FlxG.height - desc.height - 10;

		// os grupinho
		if(curSelected >= 0 && curSelected < 21)
			theGroup.text = "Yung Lixo Rework Team";
		if(curSelected >= 21 && curSelected < 26)
			theGroup.text = "Yung Lixo V1 Team";
		if(curSelected == 26)
			theGroup.text = "Agradecimentos Especiais";
		if(curSelected == 27)
			theGroup.text = "???";
		theGroup.x = Math.floor((FlxG.width / 2) - (theGroup.width / 2));
		theGroup.y = desc.y - theGroup.height - 10;

		descBG.y = theGroup.y - 10;

		socialmedia.x = FlxG.width - socialmedia.width - 8;
		socialmedia.y = descBG.y - socialmedia.height - 8;

		socialmedia.animation.curAnim.curFrame = daTeam[curSelected][5];
	}

}
