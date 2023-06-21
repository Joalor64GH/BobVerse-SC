package;

import flixel.FlxG;
import openfl.utils.Assets;

using StringTools;

class CoolUtil
{
	public static final defaultDifficulties:Array<String> = [
		'Easy',
		'Normal',
		'Hard'
	];
	public static var defaultDifficulty:String = 'Normal'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	inline public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if (num == null) num = PlayState.storyDifficulty;
		return Paths.formatToSongPath((difficulties[num] != defaultDifficulty) ? '-' + difficulties[num] : '');
	}

	inline public static function difficultyString():String
		return difficulties[PlayState.storyDifficulty].toUpperCase();

	inline public static function boundTo(value:Float, min:Float, max:Float):Float
		return Math.max(min, Math.min(max, value));

	inline public static function coolTextFile(path:String):Array<String> {
		return (Assets.exists(path)) ? [for (i in Assets.getText(path).trim().split('\n')) i.trim()] : [];
	}

	inline public static function listFromString(string:String):Array<String> {
		return string.trim().split('\n').map(str -> str.trim());
	}

	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
		return [for (i in min...max) i];

	//uhhhh does this even work at all? i'm starting to doubt
	inline public static function precacheSound(sound:String, ?library:String = null):Void
		Paths.sound(sound, library);

	inline public static function precacheMusic(sound:String, ?library:String = null):Void
		Paths.music(sound, library);

	inline public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}