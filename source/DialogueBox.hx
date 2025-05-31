package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;
	var nameDialogue:FlxText;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var portraitMamiNormal:FlxSprite;
	var portraitMamiAnnoyed:FlxSprite;
	var portraitMamiConcern:FlxSprite;
	var portraitMamiHappy:FlxSprite;
	var portraitHomuraTalk:FlxSprite;
	var portraitMamiHoly:FlxSprite;
	var portraitMamiHolyThreat:FlxSprite;
	var portraitHomuraHurt:FlxSprite;
	var portraitBoyfriendNormal:FlxSprite;
	var portraitNemuPost:FlxSprite;
	var portraitToukaPost:FlxSprite;
	var portraitAlinaPost:FlxSprite;

	var bgFade:FlxSprite;

	var arrowShadow:FlxSprite;
	var arrowDio:FlxSprite;

	var ohName:Bool = false;
	var bonk:Bool = false;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'connect':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(0, 400);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'connect' | 'reminisce' | 'salvation':
				hasDialog = true;
				box.loadGraphic(Paths.image('cutscene/dialoguebox', 'weekmami'));
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		//MAMI PORTRAITS
		portraitMamiNormal = new FlxSprite(-50, 60);
		portraitMamiNormal.loadGraphic(Paths.image('cutscene/PORTRAITS/MAMI_NORMAL', 'weekmami'));
		portraitMamiNormal.setGraphicSize(Std.int(portraitMamiNormal.width * 1.25));
		portraitMamiNormal.updateHitbox();
		portraitMamiNormal.scrollFactor.set();
		portraitMamiNormal.antialiasing = true;
		add(portraitMamiNormal);
		portraitMamiNormal.visible = false;

		portraitMamiAnnoyed = new FlxSprite(-50, 60);
		portraitMamiAnnoyed.loadGraphic(Paths.image('cutscene/PORTRAITS/MAMI_ANNOYED', 'weekmami'));
		portraitMamiAnnoyed.setGraphicSize(Std.int(portraitMamiAnnoyed.width * 1.25));
		portraitMamiAnnoyed.updateHitbox();
		portraitMamiAnnoyed.scrollFactor.set();
		portraitMamiAnnoyed.antialiasing = true;
		add(portraitMamiAnnoyed);
		portraitMamiAnnoyed.visible = false;

		portraitMamiConcern = new FlxSprite(-50, 60);
		portraitMamiConcern.loadGraphic(Paths.image('cutscene/PORTRAITS/MAMI_CONCERN', 'weekmami'));
		portraitMamiConcern.setGraphicSize(Std.int(portraitMamiConcern.width * 1.25));
		portraitMamiConcern.updateHitbox();
		portraitMamiConcern.scrollFactor.set();
		portraitMamiConcern.antialiasing = true;
		add(portraitMamiConcern);
		portraitMamiConcern.visible = false;

		portraitMamiHappy = new FlxSprite(-50, 60);
		portraitMamiHappy.loadGraphic(Paths.image('cutscene/PORTRAITS/MAMI_HAPPY', 'weekmami'));
		portraitMamiHappy.setGraphicSize(Std.int(portraitMamiHappy.width * 1.25));
		portraitMamiHappy.updateHitbox();
		portraitMamiHappy.scrollFactor.set();
		portraitMamiHappy.antialiasing = true;
		add(portraitMamiHappy);
		portraitMamiHappy.visible = false;

		portraitMamiHoly = new FlxSprite(-50, 60);
		portraitMamiHoly.loadGraphic(Paths.image('cutscene/PORTRAITS/MAMI_HOLY', 'weekmami'));
		portraitMamiHoly.setGraphicSize(Std.int(portraitMamiHoly.width * 1.25));
		portraitMamiHoly.updateHitbox();
		portraitMamiHoly.scrollFactor.set();
		portraitMamiHoly.antialiasing = true;
		add(portraitMamiHoly);
		portraitMamiHoly.visible = false;

		portraitMamiHolyThreat = new FlxSprite(-50, 60);
		portraitMamiHolyThreat.loadGraphic(Paths.image('cutscene/PORTRAITS/MAMI_somewhatHOLY', 'weekmami'));
		portraitMamiHolyThreat.setGraphicSize(Std.int(portraitMamiHolyThreat.width * 1.25));
		portraitMamiHolyThreat.updateHitbox();
		portraitMamiHolyThreat.scrollFactor.set();
		portraitMamiHolyThreat.antialiasing = true;
		add(portraitMamiHolyThreat);
		portraitMamiHolyThreat.visible = false;

		//HOMURA PORTRAITS

		portraitHomuraHurt = new FlxSprite(-50, 60);
		portraitHomuraHurt.loadGraphic(Paths.image('cutscene/PORTRAITS/HOMURA_HURT', 'weekmami'));
		portraitHomuraHurt.setGraphicSize(Std.int(portraitHomuraHurt.width * 1.25));
		portraitHomuraHurt.updateHitbox();
		portraitHomuraHurt.scrollFactor.set();
		portraitHomuraHurt.antialiasing = true;
		add(portraitHomuraHurt);
		portraitHomuraHurt.visible = false;

		portraitHomuraTalk = new FlxSprite(-50, 60);
		if (bonk)
			portraitHomuraTalk.loadGraphic(Paths.image('cutscene/PORTRAITS/HOMURA_TALK_BONK', 'weekmami'));
		else
			portraitHomuraTalk.loadGraphic(Paths.image('cutscene/PORTRAITS/HOMURA_TALK', 'weekmami'));
		portraitHomuraTalk.setGraphicSize(Std.int(portraitHomuraTalk.width * 1.25));
		portraitHomuraTalk.updateHitbox();
		portraitHomuraTalk.scrollFactor.set();
		portraitHomuraTalk.antialiasing = true;
		add(portraitHomuraTalk);
		portraitHomuraTalk.visible = false;

		//BOYFRIEND PORTRAITS

		portraitBoyfriendNormal = new FlxSprite(620, 60);
		portraitBoyfriendNormal.loadGraphic(Paths.image('cutscene/PORTRAITS/BF_NORMAL', 'weekmami'));
		portraitBoyfriendNormal.setGraphicSize(Std.int(portraitBoyfriendNormal.width * 1.25));
		portraitBoyfriendNormal.updateHitbox();
		portraitBoyfriendNormal.scrollFactor.set();
		portraitBoyfriendNormal.antialiasing = true;
		add(portraitBoyfriendNormal);
		portraitBoyfriendNormal.visible = false;

		//MAGIUS PORTRAITS

		portraitAlinaPost = new FlxSprite(-50, 60);
		portraitAlinaPost.loadGraphic(Paths.image('cutscene/PORTRAITS/ALINA_POST', 'weekmami'));
		portraitAlinaPost.setGraphicSize(Std.int(portraitAlinaPost.width * 1.25));
		portraitAlinaPost.updateHitbox();
		portraitAlinaPost.scrollFactor.set();
		portraitAlinaPost.antialiasing = true;
		add(portraitAlinaPost);
		portraitAlinaPost.visible = false;

		portraitNemuPost = new FlxSprite(-50, 60);
		portraitNemuPost.loadGraphic(Paths.image('cutscene/PORTRAITS/NEMU_POST', 'weekmami'));
		portraitNemuPost.setGraphicSize(Std.int(portraitNemuPost.width * 1.25));
		portraitNemuPost.updateHitbox();
		portraitNemuPost.scrollFactor.set();
		portraitNemuPost.antialiasing = true;
		add(portraitNemuPost);
		portraitNemuPost.visible = false;
		
		portraitToukaPost = new FlxSprite(-50, 60);
		portraitToukaPost.loadGraphic(Paths.image('cutscene/PORTRAITS/TOUKA_POST', 'weekmami'));
		portraitToukaPost.setGraphicSize(Std.int(portraitToukaPost.width * 1.25));
		portraitToukaPost.updateHitbox();
		portraitToukaPost.scrollFactor.set();
		portraitToukaPost.antialiasing = true;
		add(portraitToukaPost);
		portraitToukaPost.visible = false;
		
		add(box);

		box.screenCenter(X);

		arrowShadow = new FlxSprite(1045, 630).loadGraphic(Paths.image('cutscene/next_arrow_shadow', 'weekmami'));
		arrowShadow.alpha = 0.5;
		add(arrowShadow);

		arrowDio = new FlxSprite(1050, 560).loadGraphic(Paths.image('cutscene/next_arrow', 'weekmami'));
		add(arrowDio);

		FlxTween.tween(arrowDio, {y: 580}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut});
		FlxTween.tween(arrowShadow, {alpha: 1}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut});

		dropText = new FlxText(181, 501, Std.int(FlxG.width * 0.68), "", 39);
		dropText.font = 'Koruri Regular';
		dropText.setFormat(Paths.font("koruri.ttf"), 39);
		dropText.color = 0xFFC59D4C;
		add(dropText);

		swagDialogue = new FlxTypeText(180, 500, Std.int(FlxG.width * 0.68), "", 39);
		swagDialogue.font = 'Korui';
		swagDialogue.setFormat(Paths.font("koruri.ttf"), 39);
		swagDialogue.color = 0xFF3F2021;
		add(swagDialogue);

		nameDialogue = new FlxText(225, 432, Std.int(FlxG.width * 0.5), "Mami", 39);
		nameDialogue.font = 'Korui';
		nameDialogue.setFormat(Paths.font("koruri.ttf"), 34);
		nameDialogue.color = 0xFFFFFFFF;
		add(nameDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.random.bool(1)) //1 out of 100 for "Oh?" translation error in Magia Record EN, thanks TAU.
			{
				ohName = true;
			}

		if (FlxG.random.bool(.1)) //bonk
			{
				bonk = true;
			}	

		dropText.text = swagDialogue.text;

		dialogueOpened = true;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		var justTouched:Bool = false;
			for (touch in FlxG.touches.list)
				if (touch.justPressed)
					justTouched = true;
		
		if(PlayerSettings.player1.controls.ACCEPT || justTouched)
		{
			if (dialogueEnded)
			{
				remove(dialogue);
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
						FlxG.sound.play(Paths.sound('CUTSCENE_next'), 0.8);	

						if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
							FlxG.sound.music.fadeOut(1.5, 0);

						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							box.alpha -= 1 / 5;
							bgFade.alpha -= 1 / 5 * 0.7;
							portraitMamiNormal.visible = false;
							portraitMamiAnnoyed.visible = false;
							portraitMamiConcern.visible = false;
							portraitMamiHappy.visible = false;
							portraitHomuraTalk.visible = false;
							portraitBoyfriendNormal.visible = false;
							portraitMamiHoly.visible = false;
							portraitMamiHolyThreat.visible = false;
							portraitHomuraHurt.visible = false;
							portraitAlinaPost.visible = false;
							portraitToukaPost.visible = false;
							portraitNemuPost.visible = false;
							arrowShadow.visible = false;
							arrowDio.visible = false;
							nameDialogue.visible = false;
							swagDialogue.alpha -= 1 / 5;
							dropText.alpha = swagDialogue.alpha;
						}, 5);

						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
						});
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
					FlxG.sound.play(Paths.sound('CUTSCENE_next'), 0.8);
				}
			}
			else if (dialogueStarted)
			{
				FlxG.sound.play(Paths.sound('CUTSCENE_next'), 0.8);
				swagDialogue.skip();
				
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		swagDialogue.completeCallback = function() {
			dialogueEnded = true;
		};

		box.flipX = false;
		dialogueEnded = false;
		nameDialogue.x = 225;
		switch (curCharacter)
		{
			case 'mami-normal':
				nameDialogue.text = 'Mami';
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitHomuraTalk.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitMamiHolyThreat.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitMamiNormal.visible)
				{
					portraitMamiNormal.visible = true;
				}
			case 'mami-annoyed':
				nameDialogue.text = 'Mami';
				portraitMamiNormal.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitHomuraTalk.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitMamiHolyThreat.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitMamiAnnoyed.visible)
				{
					portraitMamiAnnoyed.visible = true;
				}
			case 'mami-concern':
				nameDialogue.text = 'Mami';
				portraitMamiNormal.visible = false;
				portraitMamiAnnoyed.visible = false;
				portraitMamiHappy.visible = false;
				portraitHomuraTalk.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitMamiHolyThreat.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitMamiConcern.visible)
				{
					portraitMamiConcern.visible = true;
				}
			case 'mami-happy':
				FlxTween.tween(portraitMamiHappy, {y: 45}, .1, {type: FlxTweenType.PINGPONG, ease: FlxEase.quadInOut, onComplete:
					function(tween:FlxTween):Void {
						if(tween.executions == 2) {
						 tween.cancel();
						}
				}}); //oncomplete dumb stuff, the bounce motion is supposed to do it once but its 9pm here lol
				nameDialogue.text = 'Mami';
				portraitMamiNormal.visible = false;
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitHomuraTalk.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitMamiHolyThreat.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitMamiHappy.visible)
				{
					portraitMamiHappy.visible = true;
				}
			case 'homura-talk':
				nameDialogue.text = 'Homura';
				portraitMamiNormal.visible = false;
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitMamiHolyThreat.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitHomuraTalk.visible)
				{
					portraitHomuraTalk.visible = true;
				}
			case 'boyfriend-normal':
				nameDialogue.x = 875;
				nameDialogue.text = 'Boyfriend';
				box.flipX = true;
				portraitMamiNormal.visible = false;
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitHomuraTalk.visible = false;
				portraitMamiHoly.visible = false;
				portraitMamiHolyThreat.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitBoyfriendNormal.visible)
				{
					portraitBoyfriendNormal.visible = true;
				}
			case 'mami-holy':
				nameDialogue.text = 'Holy Mami';
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitHomuraTalk.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitMamiHolyThreat.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitMamiHoly.visible)
				{
					portraitMamiHoly.visible = true;
				}
			case 'homura-hurt':
				nameDialogue.text = 'Homura';
				portraitMamiNormal.visible = false;
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitMamiHolyThreat.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitHomuraHurt.visible)
				{
					portraitHomuraHurt.visible = true;
				}
			case 'mami-holy-threat':
				nameDialogue.text = 'Holy Mami';
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitHomuraTalk.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitMamiHolyThreat.visible)
				{
					portraitMamiHolyThreat.visible = true;
				}
			case 'alina-post':
				nameDialogue.text = 'Alina';
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitHomuraTalk.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitHomuraHurt.visible = false;
				portraitToukaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitAlinaPost.visible)
				{
					portraitAlinaPost.visible = true;
				}

			case 'touka-post':
				nameDialogue.text = 'Touka';
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitHomuraTalk.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitNemuPost.visible = false;
				if (!portraitToukaPost.visible)
				{
					portraitToukaPost.visible = true;
				}

			case 'nemu-post':
				nameDialogue.text = 'Nemu';
				portraitMamiAnnoyed.visible = false;
				portraitMamiConcern.visible = false;
				portraitMamiHappy.visible = false;
				portraitHomuraTalk.visible = false;
				portraitBoyfriendNormal.visible = false;
				portraitMamiHoly.visible = false;
				portraitHomuraHurt.visible = false;
				portraitAlinaPost.visible = false;
				portraitToukaPost.visible = false;
				if (!portraitNemuPost.visible)
				{
					portraitNemuPost.visible = true;
				}
		}
		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
