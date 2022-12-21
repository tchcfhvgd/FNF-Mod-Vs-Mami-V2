package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	public var isAnimated:Bool = false;
	public var scaleOffset:Float = 0.0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {

		if (char == 'mami-tetris')
			{
			isAnimated = true;
			scaleOffset = -0.25;
			trace('is penpen? lets aniamte it!');
			}
		else isAnimated = false;


		if(this.char != char) {

			if (!isAnimated)
				{
					var name:String = 'icons/' + char;
					if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
					if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
					var file:Dynamic = Paths.image(name);
		
					loadGraphic(file); //Load stupidly first for getting the file size
					loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); //Then load it fr
					iconOffsets[0] = (width - 150) / 2;
					iconOffsets[1] = (width - 150) / 2;
					updateHitbox();
		
					animation.add(char, [0, 1, 2], 0, false, isPlayer);
					animation.play(char);
					this.char = char;
		
					antialiasing = ClientPrefs.globalAntialiasing;
					if(char.endsWith('-pixel')) {
						antialiasing = false;
					}
				}
			else if (isAnimated)
				{
					var name:String = 'icons/animated/' + char;
					trace(name);
	
					frames = Paths.getSparrowAtlas(name);
	
					if (frames == null)
						{
							loadGraphic('icons/icon-face');
						}
					else
						{
							animation.addByPrefix('normal', 'NORMAL', 24, true);
							animation.addByPrefix('losing', 'LOSING', 24, true);
							animation.addByPrefix('winning', 'WINNING', 24, true);
							animation.play('normal');
							this.char = char;
							antialiasing = ClientPrefs.globalAntialiasing;
						}
				}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}