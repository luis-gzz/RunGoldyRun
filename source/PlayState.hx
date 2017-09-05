package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxSort;
import flixel.util.FlxColor;
import flixel.system.scaleModes.FillScaleMode;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.FlxObject;
import flixel.ui.FlxBar;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import extension.admob.AdMob;
import extension.admob.GravityMode;
import extension.gamecenter.GameCenter;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var theWalkArea:FlxSprite;
	private var goldy:Goldy;
	//private var fill:FillScaleMode;
	
	private var shootLabel:FlxSprite;
	private var flipLabel:FlxSprite;
	
	private var timerTopEnemy: Float = .7;
	private var spawnTopEnemyBool:Bool = false;
	private var timerBottomEnemy: Float = 1.3;
	private var spawnBottomEnemyBool:Bool = false;
	public var enemyGroup:FlxTypedGroup<Enemy>;
	private var _lasers: FlxTypedGroup<Laser>;
	private var _laserBar:FlxBar;
	private var shotsLeft:Int = 3;
	private var _shotsTimer:Float = .5;
	private var _shotsRecharge:Float = .5;
	private var canFire:Bool = true;
	
	//Score Counter
	private var _metersRun:FlxText;
	private var _meters:Int;
	private var _meterTimer:Float = 1.4;
	
	private var _gameSave:FlxSave;
	
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		FlxG.camera.fade(FlxColor.BLACK, 1.2, true);
		FlxG.cameras.bgColor = 0xF4EBE2;
		
		//Admob
		AdMob.initAndroid("ca-app-pub-5984764034252420/6108256794", "ca-app-pub-5984764034252420/4631523598", GravityMode.TOP); // may also be GravityMode.TOP
		AdMob.initIOS("ca-app-pub-5984764034252420/9201323992","ca-app-pub-5984764034252420/6474320393", GravityMode.TOP); // may also be GravityMode.TOP
	
	
		_gameSave = new FlxSave();
		_gameSave.bind("GameScore");
		
		//Playarea setup
		theWalkArea = new FlxSprite(0, FlxG.height/2-2);
		theWalkArea.loadGraphic("assets/images/walkWay.png", false, 274, 2);
		
		//Enemies
		enemyGroup = new FlxTypedGroup<Enemy>();
		
		//Projectiles
		_lasers = new FlxTypedGroup<Laser>();
		add(_lasers);
		_laserBar = new FlxBar(FlxG.width / 2 - 25, 10, FlxBar.FILL_LEFT_TO_RIGHT, 50, 8);
		_laserBar.createFilledBar( 0xFFF4EBE2, 0xFF993D99,true,0xFF993D99);
		add(_laserBar);
		
		
		//Goldy
		goldy = new Goldy(50, FlxG.height / 2 - 14, _lasers, canFire);
		
		//scoreCounter
		scoreFunction();
		
		#if mobile
		instructionMobile();
		#end
		
		//Add to the stage
		add(theWalkArea);
		add(enemyGroup);
		add(_metersRun);
		add(goldy);
		
		super.create();
	}
	
	
	public function instructionMobile():Void {
		shootLabel = new FlxSprite(FlxG.width / 4 -17, FlxG.height / 2 + 20);
		shootLabel.loadGraphic("assets/images/shoot.png", false, 35, 7);
		add(shootLabel);
		flipLabel = new FlxSprite((FlxG.width / 2) + FlxG.width / 4 -11, FlxG.height / 2 + 20);
		flipLabel.loadGraphic("assets/images/flip.png", false, 23, 7);
		add(flipLabel);
		
		new FlxTimer(1.8, killIns, 1);
		
	}
	
	private function killIns(Timer:FlxTimer):Void{	
		flipLabel = FlxDestroyUtil.destroy(flipLabel);
		shootLabel = FlxDestroyUtil.destroy(shootLabel);
	}
	
	public function scoreFunction(): Void {
		
		var counterString = " " + Std.int( _meters );
		
		_metersRun = new FlxText(10, 10, -1,  counterString, 12, true);
		_metersRun.setFormat("assets/data/Vdj.ttf", 8, 0xB7B7B7, "center");
		add(_metersRun);
		
	}
	
	public function spawnSystem():Void {
		var random = Math.random();
		
		if (spawnTopEnemyBool) {
			
			var topBottomBool: Bool = true;
			
			var enemyCreation:Enemy = enemyGroup.recycle(Enemy);
				if (random <= .25)
					enemyCreation.newSwordman(topBottomBool, enemyGroup);
				else if (random <= .50)
					enemyCreation.newBarbarian(topBottomBool, enemyGroup);
				else  if (random <= .75)
					enemyCreation.newSpearman(topBottomBool, enemyGroup);
				else
					enemyCreation.newThief(topBottomBool, enemyGroup);
					
					
			//adding time back to timer
			var randomTimer;
			
			if ((enemyGroup.length < 2)){
				randomTimer = Math.random() * 1.33224525 + 1;
			}else {
			
				enemyGroup.sort(sortByX, FlxSort.DESCENDING);
			
				if (((enemyCreation.x) - enemyGroup.members[1].x) < 27){
					enemyCreation.kill();
					randomTimer = .1;
				} else
					randomTimer = Math.random() * 1.345465345 + 1;
			}
			
	
			timerTopEnemy = randomTimer; //reset spawn timer
	
			spawnTopEnemyBool = false;
		}
		
		if (spawnBottomEnemyBool) {
			var topBottomBool2: Bool = false;
			
			var enemyBottomCreation:Enemy = enemyGroup.recycle(Enemy);
				if (random <= .25)
					enemyBottomCreation.newSwordman(topBottomBool2, enemyGroup);
				else if (random <= .50)
					enemyBottomCreation.newBarbarian(topBottomBool2, enemyGroup);
				else if (random <= .75)
					enemyBottomCreation.newSpearman(topBottomBool2, enemyGroup);
				else 
					enemyBottomCreation.newThief(topBottomBool2, enemyGroup);
					
			var randomTimer2;

				
			if ((enemyGroup.length < 2)){
				randomTimer2 = Math.random() * 1.343252545 + .75;
			}else {
			
				enemyGroup.sort(sortByX, FlxSort.DESCENDING);
				
			
				if (((enemyBottomCreation.x) - enemyGroup.members[1].x) < 27){
					enemyBottomCreation.kill();
					randomTimer2 = .1;
				} else
					randomTimer2 = Math.random() * 1.342524625 + .75;
			}
			
			timerBottomEnemy = randomTimer2; //reset spawn timer
	
			spawnBottomEnemyBool = false;
		}
			
		
	}
	
	public function laserSystem():Void {
		_laserBar.currentValue = goldy.shootCounter;
		_laserBar.setRange(0, 20);
		
	}
	
	public function stuffHitStuff(Object1:FlxObject,Object2:Enemy):Void {
		Object1.kill();
		Object2.impulse();
	}
	
	public function goldyHitStuff(Object1:Goldy,Object2:FlxObject):Void {
		Object1.kill();
		FlxG.camera.shake(.02, .5, goldyDeath);
		
		//Object2.kill();
	}
	
	public function goldyDeath():Void {
		#if mobile
		AdMob.showInterstitial(0, 3);
		AdMob.onResize();
		#end
		
		if (_gameSave.data.highScoreData ==null) {
			_gameSave.data.highScoreData = _meters;	
			GameCenter.reportScore("123_456.7", _meters);
		} else {
			if (_gameSave.data.highScoreData >= _meters) {
				_gameSave.data.highScoreData = _gameSave.data.highScoreData;
			} else {
				_gameSave.data.highScoreData = _meters;
				GameCenter.reportScore("123_456.7", _meters);
				
			}
		}
		
		
		_gameSave.data.tempScore = _meters;
		_gameSave.flush();
		
		
		FlxG.switchState(new DeadState());
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		goldy = FlxDestroyUtil.destroy(goldy);
		theWalkArea = FlxDestroyUtil.destroy(theWalkArea);
		enemyGroup = FlxDestroyUtil.destroy(enemyGroup);
		_metersRun = FlxDestroyUtil.destroy(_metersRun);
		_lasers = FlxDestroyUtil.destroy(_lasers);
		
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (goldy.alive){
			_meterTimer -= FlxG.elapsed;
			if (_meterTimer<=0){
				_metersRun.destroy();
				_meters ++;
				_meterTimer = .5;
				scoreFunction();
			}
		}
		
		timerTopEnemy -= FlxG.elapsed;
		if (timerTopEnemy <= 0) {
			spawnTopEnemyBool = true;
		}
		
		timerBottomEnemy -= FlxG.elapsed;
		if (timerBottomEnemy <= 0) {
			spawnBottomEnemyBool = true;
		}
		
		laserSystem();	
	
		spawnSystem();
		
		FlxG.collide(_lasers, enemyGroup,  stuffHitStuff); 
		FlxG.overlap(goldy, enemyGroup,  goldyHitStuff); 

		super.update();
	}	
	
	function sortByX(Order:Int, Object1:Enemy, Object2:Enemy):Int
	{
		return FlxSort.byValues(Order, Object1.x, Object2.x);
	}
}