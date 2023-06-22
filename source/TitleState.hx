package;

#if desktop
import Discord.DiscordClient;
#end

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import flixel.graphics.frames.FlxAtlasFrames;
import options.VisualsSubState;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;

using StringTools;

class TitleState extends MusicBeatState
{
	public static var initialized:Bool = false;

	var credGroup:FlxGroup;
	var textGroup:FlxGroup;

	var credTextShit:Alphabet;

	var blackScreen:FlxSprite;

	var joalorSpr:FlxSprite;

	var composeSpr:FlxSprite;
	var animateSpr:FlxSprite;
	var chartSpr:FlxSprite;
	var artSpr:FlxSprite;

	var candance:Bool = true;

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		swagShader = new ColorSwap();
		super.create();

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});

		if (!candance)
			candance = true;
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('BoBMenu'), 0);
			}
		}

		Conductor.changeBPM(125);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();

		swagShader = new ColorSwap();
		gfDance = new FlxSprite(512, 40);
		
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/title/GF_assets.png";
		if (!FileSystem.exists(path))
		{
			path = "mods/images/title/GF_assets.png";
		}
		if (!FileSystem.exists(path))
		{
			path = "assets/images/title/GF_assets.png";
		}
		gfDance.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path), File.getContent(StringTools.replace(path, ".png", ".xml")));
		#else
		gfDance.frames = Paths.getSparrowAtlas('title/GF_assets');
		#end
		gfDance.animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.animation.addByPrefix('Hey', 'GF Cheer', 24, false);
		
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;
		
		add(gfDance);
		if (swagShader != null)
			gfDance.shader = swagShader.shader;
		add(logoBl);
		if (swagShader != null)
			logoBl.shader = swagShader.shader;

		titleText = new FlxSprite(100, 576);
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/titleEnter.png";
		if (!FileSystem.exists(path)){
			path = "mods/images/titleEnter.png";
		}
		if (!FileSystem.exists(path)){
			path = "assets/images/titleEnter.png";
		}
		titleText.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path),File.getContent(StringTools.replace(path,".png",".xml")));
		#else
		
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		#end
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
		credTextShit.visible = false;

		joalorSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('title/joalor64'));
		add(joalorSpr);
		joalorSpr.visible = false;
		joalorSpr.setGraphicSize(Std.int(joalorSpr.width * 0.8));
		joalorSpr.updateHitbox();
		joalorSpr.screenCenter(X);
		joalorSpr.antialiasing = ClientPrefs.globalAntialiasing;

		composeSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('title/composers'));
		add(composeSpr);
		composeSpr.visible = false;
		composeSpr.setGraphicSize(Std.int(composeSpr.width * 0.8));
		composeSpr.updateHitbox();
		composeSpr.screenCenter(X);
		composeSpr.antialiasing = ClientPrefs.globalAntialiasing;

		artSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('title/artists'));
		add(artSpr);
		artSpr.visible = false;
		artSpr.setGraphicSize(Std.int(artSpr.width * 0.8));
		artSpr.updateHitbox();
		artSpr.screenCenter(X);
		artSpr.antialiasing = ClientPrefs.globalAntialiasing;

		chartSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('title/charters'));
		add(chartSpr);
		chartSpr.visible = false;
		chartSpr.setGraphicSize(Std.int(chartSpr.width * 0.8));
		chartSpr.updateHitbox();
		chartSpr.screenCenter(X);
		chartSpr.antialiasing = ClientPrefs.globalAntialiasing;

		animateSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('title/animators'));
		add(animateSpr);
		animateSpr.visible = false;
		animateSpr.setGraphicSize(Std.int(animateSpr.width * 0.8));
		animateSpr.updateHitbox();
		animateSpr.screenCenter(X);
		animateSpr.antialiasing = ClientPrefs.globalAntialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (initialized && !transitioning && skippedIntro)
		{
			if(pressedEnter)
			{
				if(titleText != null) titleText.animation.play('press');

				FlxTween.tween(logoBl, {x: -1500, angle: 10, alpha: 0}, 2, {ease: FlxEase.expoInOut});
				FlxTween.tween(gfDance, {x: -1500}, 3.7, {ease: FlxEase.expoInOut});
				FlxTween.tween(titleText, {y: 1500}, 3.7, {ease: FlxEase.expoInOut});
				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;

				gfDance.animation.play('Hey');
				candance = false;

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		FlxTween.tween(FlxG.camera, {zoom:1.03}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});

		if(logoBl != null) 
			logoBl.animation.play('bump', true);

		if (candance)
		{
			if(gfDance != null) 
			{
				danceLeft = !danceLeft;
				if (danceLeft)
					gfDance.animation.play('danceRight');
				else
					gfDance.animation.play('danceLeft');
			}
		}

		if(!closedState) {
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('BoBMenu'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.7);
					createCoolText(['Directed by']);
				case 2:
					addMoreText('Unhappily');
				case 3:
					addMoreText('niceboy214');
				case 4:
					deleteCoolText();
				case 5:
					createCoolText(['Programmed by'], -40);
				case 7:
					addMoreText('Joalor64', -40);
					joalorSpr.visible = true;
				case 8:
					deleteCoolText();
					joalorSpr.visible = false;
				case 9:
					createCoolText(['Artists']);
					artSpr.visible = true;
				case 10:
					deleteCoolText();
					artSpr.visible = false;
					createCoolText(['Animators']);
					animateSpr.visible = true;
				case 11:
					deleteCoolText();
					animateSpr.visible = false;
					createCoolText(['Composers']);
					composeSpr.visible = true;
				case 12:
					deleteCoolText();
					composeSpr.visible = false;
					createCoolText(['Charters']);
					chartSpr.visible = true;
				case 13:
					deleteCoolText();
					chartSpr.visible = false;
					createCoolText(['Friday Night Funkin']);
				case 14:
					addMoreText('Funkin Into the');
				case 15:
					addMoreText('Bob');
				case 16:
					addMoreText('Verse');

				case 17:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(joalorSpr);
			remove(artSpr);
			remove(animateSpr);
			remove(composeSpr);
			remove(chartSpr);

			remove(credGroup);

			FlxG.camera.flash(FlxColor.WHITE, 4);

			// nabbed from kade engine
			logoBl.angle = -4;

			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				if (logoBl.angle == -4)
					FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
				if (logoBl.angle == 4)
					FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
			}, 0);


			skippedIntro = true;
		}
	}
}