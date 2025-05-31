package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		//'gacha',
		// #if ACHIEVEMENTS_ALLOWED 'awards', //
		// #end
		'credits',
		'donate',
		'options'
	];
	var canMove:Bool = false;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var menuInfomation:FlxText;
	var mamiLogo:FlxSprite;
	var menuCharacterNum:Int = 0;
	var titleCharacter:FlxSprite;
	var menuCharacterIcon:HealthIcon;
	var menuBGNum:Int = 0;

	override function create()
	{
		menuBGNum = FlxG.random.int(0, 1);
		WeekData.loadTheFirstEnabledMod();
		FlxG.save.data.progressStoryClearHard = true; // Sector add the progressStoryClearHard stuff so that way works properly
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;
		Conductor.changeBPM(120);

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/menu_' + menuBGNum));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;

		// magenta.scrollFactor.set();

		// random character code here
		if (FlxG.save.data.progressStoryClearHard)
		{
			menuCharacterNum = FlxG.random.int(0, 2);
		}
		else
		{
			menuCharacterNum = FlxG.random.int(0, 1);
		}

		titleCharacter = new FlxSprite(FlxG.width * 0.25, -50);
		titleCharacter.frames = Paths.getSparrowAtlas('mainmenu/titlecharacter_' + menuCharacterNum);
		titleCharacter.antialiasing = ClientPrefs.globalAntialiasing;
		titleCharacter.setGraphicSize(Std.int(titleCharacter.width * 1.35));
		titleCharacter.animation.addByPrefix('idle', 'IDLE', 24, false);
		titleCharacter.animation.play('idle');
		titleCharacter.scrollFactor.set(0, 0.05);
		titleCharacter.updateHitbox();
		titleCharacter.alpha = 0;
		add(titleCharacter);

		mamiLogo = new FlxSprite(768, 25);
		mamiLogo.frames = Paths.getSparrowAtlas('mainmenu/mamilogo');
		mamiLogo.antialiasing = ClientPrefs.globalAntialiasing;
		mamiLogo.setGraphicSize(Std.int(mamiLogo.width * 0.5));
		mamiLogo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		mamiLogo.animation.play('bump');
		mamiLogo.scrollFactor.set(0, 0);
		mamiLogo.updateHitbox();
		add(mamiLogo);
		FlxTween.linearMotion(mamiLogo, 768, -1280, 768, 25, 2, {ease: FlxEase.quadOut});

		var menuBottom:FlxSprite = new FlxSprite(0, 1280).loadGraphic(Paths.image('mainmenu/menubottom_' + menuCharacterNum));
		menuBottom.scrollFactor.set(0, 0);
		menuBottom.setGraphicSize(Std.int(menuBottom.width * 1));
		menuBottom.updateHitbox();
		menuBottom.screenCenter();
		menuBottom.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBottom);
		FlxTween.linearMotion(menuBottom, 0, 1280, 0, 0, 2, {ease: FlxEase.quadOut});

		var menuSlide:FlxSprite = new FlxSprite(-1280, 0).loadGraphic(Paths.image('mainmenu/menuslide'));
		menuSlide.scrollFactor.set(0, 0);
		menuSlide.setGraphicSize(Std.int(menuSlide.width * 1));
		menuSlide.updateHitbox();
		menuSlide.screenCenter();
		menuSlide.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuSlide);
		FlxTween.linearMotion(menuSlide, 0, -1280, 0, 0, 2, {ease: FlxEase.quadOut});

		if (FlxG.save.data.progressStoryClearHard)
		{
			switch (menuCharacterNum)
			{
				case 0:
					menuCharacterIcon = new HealthIcon("bf", false);
				case 1:
					menuCharacterIcon = new HealthIcon("mami", false);
				case 2:
					menuCharacterIcon = new HealthIcon("mami-holy", false);
			}
		}
		else
		{
			switch (menuCharacterNum)
			{
				case 0:
					menuCharacterIcon = new HealthIcon("bf", false);
				case 1:
					menuCharacterIcon = new HealthIcon("mami", false);
			}
		}

		menuCharacterIcon.x = 1100;
		menuCharacterIcon.y = 550;
		menuCharacterIcon.flipX = true;
		menuCharacterIcon.setGraphicSize(Std.int(menuCharacterIcon.width * 1.5));
		menuCharacterIcon.animation.curAnim.curFrame = 2;
		menuCharacterIcon.angle = -10;
		menuCharacterIcon.alpha = 0.0;
		menuCharacterIcon.scrollFactor.set(0, 0);
		add(menuCharacterIcon);
		FlxTween.linearMotion(menuCharacterIcon, 1100, 1280, 1100, 550, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(menuCharacterIcon, {angle: 10}, 2.5, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut});
		FlxTween.tween(menuCharacterIcon, {alpha: 1}, 3, {type: FlxTweenType.ONESHOT, ease: FlxEase.quadInOut});

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		menuInfomation = new FlxText(110, 675, 1000, "Please select a option.", 28);
		menuInfomation.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		menuInfomation.scrollFactor.set(0, 0);
		menuInfomation.borderSize = 2;
		add(menuInfomation);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/FNF_main_menu_assets');
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.x = 30;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			FlxTween.linearMotion(menuItem, 30, -1280 + (i * 100), 30, 40 + (i * 100), 2, {ease: FlxEase.quadOut});
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, 'Vs. Mami FULL WEEK [v1.5]', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Psych Engine 0.5.2h", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			titleCharacter.x = -600;
			titleCharacter.alpha = 0;
			FlxTween.tween(titleCharacter, {alpha: 1}, 4, {ease: FlxEase.quartOut});
			FlxTween.tween(titleCharacter, {x: 200}, 8, {ease: FlxEase.quartOut});
			canMove = true;
		});
		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
		{
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if (!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2]))
			{ // It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
		
		addTouchPad("UP_DOWN", "A_B");
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement()
	{
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin && canMove)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
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
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.x = 0;
		});
	}

	override function beatHit()
	{
		FlxG.log.add(curBeat);

		if (curBeat % 2 == 0)
		{
			mamiLogo.animation.play('bump', true);
			titleCharacter.animation.play('idle', true);
		}

		if (curBeat % 4 == 0)
		{
			FlxTween.tween(FlxG.camera, {zoom: 1.02}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
		}

		super.beatHit();
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		switch (curSelected) // putting this in update because changeitem was not being nice to me
		{
			case 0:
				menuInfomation.text = "Play through the Story Mode!";
				menuInfomation.color = FlxColor.WHITE;
			case 1:
				menuInfomation.text = "Play any song from the mod you'd like.";
				menuInfomation.color = FlxColor.WHITE;
			case 2:
				menuInfomation.text = "View the list of people who help created this mod.";
				menuInfomation.color = FlxColor.WHITE;
			case 3:
				menuInfomation.text = "Donate to the OFFICAL Friday Night Funkin' team.";
				menuInfomation.color = FlxColor.WHITE;
			case 4:
				menuInfomation.text = "Configure your settings here.";
				menuInfomation.color = FlxColor.WHITE;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			if (canMove)
				FlxTween.completeTweensOf(spr);
			spr.x = 0;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if (menuItems.length > 4)
				{
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
