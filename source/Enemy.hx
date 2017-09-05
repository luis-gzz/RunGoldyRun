package ;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.*;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxTimer;
//import flixel.addons.weapon.FlxBullet;
//import flixel.addons.weapon.FlxWeapon;

/**
 * ...
 * @author Luis Gonzalez
 */
class Enemy extends FlxSprite
{
	//public var thiefKnife:FlxWeapon;
	private var _health = 4;
	private var _enemies: FlxTypedGroup<Enemy>;
	private var firstSpawn:Bool = true;
	
	public function new() 
	{
		super();
		maxVelocity.set(125, 0);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		//drag.set(5500, 100);
		
	}
	
	public function newSwordman( topBottomBool:Bool, Enemies:FlxTypedGroup<Enemy>): Enemy {
		alive = true;
		visible = true;
		active = true;
		solid = true;
		exists = true;
		_health = 5;
		_enemies = Enemies;
		
		var top:Bool = topBottomBool;
		
		loadGraphic("assets/images/theSwordsman.png", true, 21, 20);
		animation.add("walk", [0,1], 5, true);
		
		x = FlxG.width + 50;
		
		
		var random = Math.random();
		if (top) {
			y = FlxG.height / 2 - 22;
			facing = FlxObject.UP;
		}
		else {
			y = FlxG.height / 2 ;
			facing = FlxObject.DOWN;
		}
		
		velocity.x = -107 + -(Math.random()*25);
		//acceleration.x = -50;
		
		return this;
	}
	
	public function newSpearman(topBottomBool:Bool, Enemies:FlxTypedGroup<Enemy>): Enemy {
		alive = true;
		visible = true;
		active = true;
		solid = true;
		exists = true;
		_health = 5;
		_enemies = Enemies;
		
		var top:Bool = topBottomBool;
		loadGraphic("assets/images/theSpearman.png", true, 25, 21);
		animation.add("walk", [0, 1], 5, true);
		
		x = FlxG.width + 50;

		var random1 = Math.random();
		if (top) {
			y = FlxG.height / 2 - 23;
			facing = FlxObject.UP;
		}
		else {
			y = FlxG.height / 2 ;
			facing = FlxObject.DOWN;
		}
			
		velocity.x = -115 + -(Math.random()*25);
		//acceleration.x = -50;
		
		return this;
	}
	
	public function newBarbarian( topBottomBool:Bool, Enemies:FlxTypedGroup<Enemy>): Enemy {
		alive = true;
		visible = true;
		active = true;
		solid = true;
		exists = true;
		_health = 5;
		_enemies = Enemies;
		
		var top:Bool = topBottomBool;
		
		loadGraphic("assets/images/theBarbarian2.png", true, 21, 20);
		animation.add("walk", [0, 1], 5, true);
		
		x = FlxG.width + 50;
	
			
		var random = Math.random();
		if (top) {
			y = FlxG.height / 2 - 22;
			facing = FlxObject.UP;
		}
		else {
			y = FlxG.height / 2 ;
			facing = FlxObject.DOWN;
		}
		
		velocity.x = -125 + -(Math.random()*25);
		//acceleration.x = -50;
		
		return this;
	}
	
	public function newThief( topBottomBool:Bool, Enemies:FlxTypedGroup<Enemy>): Enemy {
		alive = true;
		visible = true;
		active = true;
		solid = true;
		exists = true;
		_health = 5;
		_enemies = Enemies;
		
		var top:Bool = topBottomBool;
		
		loadGraphic("assets/images/theThief.png", true, 16, 20);
		animation.add("walk", [0,1], 5, true);
		
		x = FlxG.width + 50;
		
	
			
		if (top) {
			y = FlxG.height / 2 - 22;
			facing = FlxObject.UP;
		}
		else {
			y = FlxG.height / 2 ;
			facing = FlxObject.DOWN;
		}
		
		velocity.x = -102 + -(Math.random()*25);
		//acceleration.x = -50;

		return this;
	}
	
	public function takeDamage():Void {
		
		_health--;
		
	}
	
	public function impulse():Void {	
		velocity.x = 1;
		new FlxTimer(.2, resetVelocity, 1);
	}
	
	private function resetVelocity(Timer:FlxTimer):Void{	
		velocity.x = -105 + -(Math.random()*45);
	}
	
	override public function update():Void
	{
		animation.play("walk");

		if (x < -21 )
			kill();
			
			
		super.update();
	}
	
	override public function kill(): Void {
		super.kill();
		exists = false;
		
	}
	
	function sortByX(Order:Int, Object1:Enemy, Object2:Enemy):Int
	{
		return FlxSort.byValues(Order, Object1.x, Object2.x);
	}
	
}