package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.FillScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
import extension.gamecenter.GameCenter;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	private var theWalkArea:FlxSprite;
	private var fill:FillScaleMode;
	private var lifeTimeMeters:Int;
	private var goldy:FlxSprite;
	private var title:FlxSprite;
	private var playBtn:FlxButton;
	private var trophyBtn:FlxButton;
	private var soundBtn:FlxButton;
	private var _totalMetersRun :FlxText;
	private var _gameSave:FlxSave;
	private var _credits:FlxSprite;
	
	override public function create():Void
	{
		
		
		#if (mobile)
		FlxG.mouse.visible = false;
		#end
		
		fill = new FillScaleMode();
		FlxG.scaleMode = fill;
		FlxG.cameras.bgColor = 0xF4EBE2;
		
		_gameSave = new FlxSave();
		_gameSave.bind("GameScore");
		
		
		theWalkArea = new FlxSprite(0, FlxG.height/2+3);
		theWalkArea.loadGraphic("assets/images/walkWay.png", false, 274, 2);
		add(theWalkArea);
		
		goldy = new FlxSprite(FlxG.width / 2 - 6, FlxG.height / 2 - 9);
		goldy.loadGraphic("assets/images/goldy.png", false);
		add(goldy);
		
		title = new FlxSprite(FlxG.width/2-33, 5);
		title.loadGraphic("assets/images/title.png", false);
		add(title);
		
		playBtn = new FlxButton(FlxG.width / 2 - 36, FlxG.height - 41, "", startGame);
		playBtn.loadGraphic("assets/images/playBtn.png", true, 75, 15);
		add(playBtn);
		
		trophyBtn = new FlxButton(FlxG.width / 2 + 14, FlxG.height - 21, "", rankTables);
		trophyBtn.loadGraphic("assets/images/trophyBtn.png", true, 10, 10);
		add(trophyBtn);
		
		soundBtn = new FlxButton(FlxG.width / 2 -21, FlxG.height - 21, "", muteGame);
		soundBtn.loadGraphic("assets/images/soundBtn.png", true, 10, 10);
		add(soundBtn);
		
		_credits = new FlxSprite(1, FlxG.height - 5);
		_credits.loadGraphic("assets/images/_credits.png", false, 60, 4);
		add(_credits);
		
		totalMetersFucntion();
		
		GameCenter.authenticate();

		super.create();

		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	public function totalMetersFucntion():Void {
		if (_gameSave.data.totalMeters ==null) {
			lifeTimeMeters = 0;
			_gameSave.data.totalMeters = lifeTimeMeters;
			
		} else {
			lifeTimeMeters = _gameSave.data.totalMeters;
		}
		
		var counterString = "Lifetime Distance: " + Std.int( lifeTimeMeters );
		_totalMetersRun = new FlxText(FlxG.width/2 -67, FlxG.height/2 +7, -1,  counterString, 12, true);
		_totalMetersRun.setFormat("assets/data/Vdj.ttf", 8, 0xB7B7B7, "center");
		
		add(_totalMetersRun);
		
		_gameSave.data.muted = FlxG.sound.muted;
		
		_gameSave.close();
	}
	 
	override public function destroy():Void
	{
		
		goldy = FlxDestroyUtil.destroy(goldy);
		theWalkArea = FlxDestroyUtil.destroy(theWalkArea);
		playBtn = FlxDestroyUtil.destroy(playBtn);
		trophyBtn = FlxDestroyUtil.destroy(trophyBtn);
		soundBtn = FlxDestroyUtil.destroy(soundBtn);
		title = FlxDestroyUtil.destroy(title);
		_credits = FlxDestroyUtil.destroy(_credits);
		
		super.destroy();
	}
	
	public function startGame():Void {
		FlxG.camera.fade(FlxColor.BLACK, 1.2, false ,function() {
				FlxG.switchState(new PlayState());
		});
	}
	
	public function rankTables():Void {
		GameCenter.showLeaderboard ("123_456.7") ;
			
	}
	
	public function muteGame():Void {
	
		
		if(FlxG.sound.muted == false){
			FlxG.sound.muted = true;
		}else if (FlxG.sound.muted == true) {
			FlxG.sound.muted = false;
		}
		
		
		
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		#if mobile 
		for (touch in FlxG.touches.list)
		{	
			if (touch.overlaps(playBtn))
			{
				FlxG.camera.fade(FlxColor.BLACK, 1.2, false ,function() {
				FlxG.switchState(new PlayState());
				});
			}
		}
		#end
		super.update();

	}
}