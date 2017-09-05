package ;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.input.touch.FlxTouch;

/**
 * ...
 * @author Luis Gonzalez
 */
class Goldy extends FlxSprite
{
	private var _lasers: FlxTypedGroup<Laser>;
	private var _timer:Float = 0.001;
	private var _timerShots:Float = 0.15;
	private var _shotsRecharge:Float = .5;
	private var canFire:Bool = true;
	public var shotsLeft:Int = 3;
	private var canFlip:Bool = true; 
	public var shootCounter:Int;
	private var resetShots:Bool = false;
	private var notZero:Bool = false;
	private var fastReload:Bool = false;
	
	public function new(X:Float=0, Y:Float=0, Lsers:FlxTypedGroup<Laser> , canFire:Bool) 
	{
		
		
		super(X, Y);
		_lasers = Lsers;
		//_canFire = canFire;
		loadGraphic("assets/images/goldyRun.png", true, 12, 12);
		animation.add("walk", [1, 2], 7, true);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		
		shootCounter = 20;
		new FlxTimer(1, startWalk, 1);
		

	}
	
	private function startWalk(Timer:FlxTimer):Void
	{
		animation.play("walk");
		
	}
	
	override public function update ():Void {
		movement();
		super.update();
	}
	
	public function movement (): Void {
		var shouldRecharge:Bool = false;
		
		
		
		#if mobile 
		for (touch in FlxG.touches.list)
		{	
			
		
			if (touch.justPressed && touch.x > FlxG.width/2 )
			{
				if ( y == FlxG.height / 2){
					
					facing = FlxObject.UP;
					y = FlxG.height / 2 - 14;
					
					
				}else if (touch.justPressed && y == FlxG.height / 2 - 14) {
					
					facing = FlxObject.DOWN;
					y = FlxG.height / 2;
					
				}
			}
			
			_timer -= FlxG.elapsed;
			_timerShots -= FlxG.elapsed;
			if (_timer <= 0 ) {	
				if (shootCounter > 0 && touch.pressed && touch.x < FlxG.width / 2 ) {
					var laser:Laser = _lasers.recycle(Laser);
					laser.create(getMidpoint()); 	
					_timer = .01; //reset spawn timer
					shootCounter--;
				} 
	
			}
			if (_timerShots <= 0) {
				
				if (shootCounter > 0 && shootCounter < 20) {
					shootCounter++;
						_timerShots = .29;
				}
				
				
				if (shootCounter == 0 && !notZero) {
						new FlxTimer(3, startReload, 1);
						notZero = true;
				}
				
			}
		}
		
		#end

		#if (web || desktop)
	
		
		if (FlxG.keys.justReleased.X && y == FlxG.height / 2 - 14) {
			facing = FlxObject.DOWN;
			y = FlxG.height / 2;
			
		} else if (FlxG.keys.justReleased.X && y == FlxG.height / 2) {
			facing = FlxObject.UP;
			y = FlxG.height / 2 - 14;
		}
		
		
		_timer -= FlxG.elapsed;
		_timerShots -= FlxG.elapsed;
			if (_timer <= 0) {	
				
				if (shootCounter > 0  && FlxG.keys.pressed.Z ) {
					
					var laser:Laser = _lasers.recycle(Laser);
					laser.create(getMidpoint()); 	
					_timer = .01; //reset spawn timer
					shootCounter--;
				} 
				
			}
			if (_timerShots <= 0) {
				if (shootCounter > 0 && shootCounter < 20) {
					shootCounter++;
					_timerShots = .29;
				}
				
				if (shootCounter == 0 && !notZero) {
						new FlxTimer(3, startReload, 1);
						notZero = true;
				}
					
				
			}
			
			
			
		#end
		
	}
	
	private function startReload(Timer:FlxTimer):Void {
		resetTimers();
		shootCounter = 20;
		notZero = false;
		
		
	}
	
	private function resetTimers():Void {
		_timerShots = .1;
		_timer = .01;
		
	}
	
}