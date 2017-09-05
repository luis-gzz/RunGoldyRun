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
class DeadState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	private var theWalkArea:FlxSprite;
	private var fill:FillScaleMode;
	
	private var goldy:FlxSprite;
	private var spearman:FlxSprite;
	private var title:FlxSprite;
	private var playBtn:FlxButton;
	private var trophyBtn:FlxButton;
	private var soundBtn:FlxButton;
	private var _highScore:FlxText;
	private var _lastScore:FlxText;
	private var _gameScore:Int;
	
	private var _gameSave:FlxSave;
	
	
	override public function create():Void
	{
		#if (desktop||web)
		FlxG.mouse.visible = true;
		#end
		fill = new FillScaleMode();
		FlxG.scaleMode = fill;
		FlxG.cameras.bgColor = 0xF4EBE2;
		
		_gameSave = new FlxSave();
		_gameSave.bind("GameScore");
		
		theWalkArea = new FlxSprite(0, FlxG.height/2+3);
		theWalkArea.loadGraphic("assets/images/walkWay.png", false, 274, 2);
		add(theWalkArea);
		
		goldy = new FlxSprite(FlxG.width / 2 - 38, FlxG.height / 2 - 9);
		goldy.loadGraphic("assets/images/goldy.png", false);
		goldy.scale.y = -1;
		add(goldy);
		
		spearman = new FlxSprite(FlxG.width / 2 + 20, FlxG.height / 2 -17);
		spearman.loadGraphic("assets/images/theSpearman.png", true, 25, 20);
		spearman.animation.add("walk", [2], 5, false);
		spearman.animation.play("walk");
		add(spearman);
		
		title = new FlxSprite(FlxG.width/2-38,10);
		title.loadGraphic("assets/images/urDead.png", false);
		add(title);
		
		playBtn = new FlxButton(FlxG.width / 2 - 46, FlxG.height - 41, "", startGame);
		playBtn.loadGraphic("assets/images/restartBtn.png", true, 94, 10);
		add(playBtn);
		
		trophyBtn = new FlxButton(FlxG.width / 2 + 14, FlxG.height - 21, "", rankTable);
		trophyBtn.loadGraphic("assets/images/trophyBtn.png", true, 10, 10);
		add(trophyBtn);
		
		soundBtn = new FlxButton(FlxG.width / 2 -21, FlxG.height - 21, "", muteGame);
		soundBtn.loadGraphic("assets/images/soundBtn.png", true, 10, 10);
		add(soundBtn);
		
		
		
		highScoreFunction();
		
		super.create();
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	public function highScoreFunction():Void {
		
		var gameScore = _gameSave.data.tempScore;
		var highScore = 0;
		
		/*
		if (_gameSave.data.highScoreData ==null) {
			_gameSave.data.highScoreData = gameScore;
		
		} else {
			var tempHigh = _gameSave.data.highScoreData;
			if (tempHigh >= gameScore) {
				highScore = _gameSave.data.highScoreData;
			} else {
				highScore = gameScore;
				_gameSave.data.highScoreData = gameScore;
				
				
			}
		}
		*/
		
		var counterString = "Highscore: " + Std.int( _gameSave.data.highScoreData );
		_highScore = new FlxText(FlxG.width/2 - 45, FlxG.height/2 +7, -1,  counterString, 12, true);
		_highScore.setFormat("assets/data/Vdj.ttf", 8, 0xB7B7B7, "center");
		add(_highScore);
		
		var counterString1 = "" + Std.int( gameScore );
		_lastScore = new FlxText(FlxG.width/2 -15, FlxG.height/2 -13, -1,  counterString1, 18, true);
		_lastScore.setFormat("assets/data/Vdj.ttf", 16, 0xB7B7B7, "center");
		add(_lastScore);
		
		_gameSave.data.totalMeters += gameScore;
		var gamecenterSubmit = _gameSave.data.totalMeters;
		
		GameCenter.reportScore("098_765.4", gamecenterSubmit);
	
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
		spearman = FlxDestroyUtil.destroy(spearman);
		_highScore = FlxDestroyUtil.destroy(_highScore);
		_lastScore = FlxDestroyUtil.destroy(_lastScore);
		
		super.destroy();
	}
	
	public function startGame():Void {
		FlxG.camera.fade(FlxColor.BLACK, 1.2, false ,function() {
				FlxG.switchState(new PlayState());
		});
	}
	
	public function rankTable():Void {
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