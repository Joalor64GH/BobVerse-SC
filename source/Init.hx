package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Init extends FlxState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
    public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
    public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    var epicSprite:FlxSprite;

    public function new() 
    {
	super();

	persistentUpdate = true;
	persistentDraw = true;
    }

    override function create()
    {
        Paths.clearStoredMemory();
	Paths.clearUnusedMemory();

	var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        bg.scale.set(10, 10);
	bg.screenCenter();
        add(bg);

        epicSprite = new FlxSprite().loadGraphic(Paths.image('logo')); // placeholder for now
        epicSprite.antialiasing = ClientPrefs.globalAntialiasing;
        epicSprite.angularVelocity = 30;
	epicSprite.screenCenter();
        add(epicSprite);
        
        load();

        new FlxTimer().start(4, function(timer) 
	{
		startGame();
	});

        super.create();
    }

    override function update(elapsed)
    {
	if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		skip();

	super.update(elapsed);
    }

    function load()
    {
        #if LUA_ALLOWED
	Paths.pushGlobalMods();
	#end
        // Just to load a mod on start up if ya got one. For mods that change the menu music and bg
	WeekData.loadTheFirstEnabledMod();

	FlxG.game.focusLostFramerate = 60;

	FlxG.sound.muteKeys = muteKeys;
	FlxG.sound.volumeDownKeys = volumeDownKeys;
	FlxG.sound.volumeUpKeys = volumeUpKeys;
		
	FlxG.keys.preventDefaultKeys = [TAB];

	PlayerSettings.init();

        FlxG.save.bind('bobverse', 'fitbvteam');
		
	ClientPrefs.loadPrefs();
		
	Highscore.load();

        if(!initialized && FlxG.save.data != null && FlxG.save.data.fullscreen)
	{
		FlxG.fullscreen = FlxG.save.data.fullscreen;
	}

	if (FlxG.save.data.weekCompleted != null)
	{
		StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
	}

	FlxG.mouse.visible = false;
        
	#if desktop
	if (!DiscordClient.isInitialized)
	{
		DiscordClient.initialize();
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		});
	}
	#end
    }

    function skip() 
    {
	startGame();
    }

    function startGame() 
    {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() 
        {
		FlxG.switchState(new TitleState());
	});
    }
}
