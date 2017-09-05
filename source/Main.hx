package;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxSave;
import extension.admob.AdMob;
import extension.admob.GravityMode;
import extension.gamecenter.GameCenter;
import extension.gamecenter.GameCenterEvent;

class Main extends Sprite 
{
	var gameWidth:Int = 224; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 126; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = MenuState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	private var _tf:TextField;

	// You can pretty much ignore everything from here on - your code should go in your states.
	
	public static function main():Void
	{	
		Lib.current.addChild(new Main());
	}
	
	public function new() 
	{
		super();
		
		if (stage != null) 
		{
			init();
		}
		else 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	private function init(?E:Event):Void 
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		setupGame();
	}
	
	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}
		
		

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
		
		var _save:FlxSave = new FlxSave();
		_save.bind("GameScore");
		if (_save.data.volume != null)
		{
			FlxG.sound.volume = _save.data.volume;
		}
		_save.close();
		
		#if flash
		FlxG.sound.playMusic("assets/music/soundtrack.mp3", .50, true);
		#else
		FlxG.sound.playMusic("assets/music/soundtrack.ogg", .50, true);
		#end
		
		// Add TextField
		//addTextField();
		
        // Connect to GameCenter
        connectToGameCenter();

		
		FlxG.sound.muted = false;
	}
	
	/*private function addTextField():Void {
		_tf = new TextField();
		_tf.width = 200;
		_tf.selectable = false;
		_tf.type = TextFieldType.DYNAMIC;
        addChild(_tf);
	}*/

	private function connectToGameCenter():Void {
		//_tf.text = "Connecting...";
        GameCenter.addEventListener(GameCenterEvent.AUTH_SUCCESS, onGC_authSuccess); 
		GameCenter.addEventListener(GameCenterEvent.AUTH_FAILURE, onGC_authFailure);

		GameCenter.authenticate();
		
    }

	private function onGC_authSuccess():Void {
        //_tf.text = "Welcome " + GameCenter.getPlayerName() + "!!!";
    }

    private function onGC_authFailure():Void {
        //_tf.text = "GameCenter Auth Failed...";
    }

}