package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

class Laser extends FlxSprite
{
	private var _timer:Float;
	
	public function new()
	{
		super();
		offset.set(1, 1);
	}
	public function create(Location:FlxPoint):Laser {
		alive = true;
		visible = true;
		active = true;
		solid = true;
		_timer = .5;
		
		
		//if (_red)
			//loadGraphic("assets/images/laser1.png", false, 5, 1);
		//else if (_purple)
			loadGraphic("assets/images/laser2.png", false, 5, 1);
		//else if (_blue)
			//loadGraphic("assets/images/laser3.png", false, 5, 1);
		
		velocity.x = 300;
		
		x = Location.x + 2;
		
		if (Location.y < FlxG.height/2)
			y = Location.y - 2;
		else 
			y = Location.y + 2;
		
		
		return this;
	}
	
	
	override public function update():Void
	{
		_timer -= FlxG.elapsed;
		if (_timer <= 0)
			kill();
		super.update();
	}
	
	override public function kill():Void
	{
		alive = false;
		solid = false;
		visible = false;
		active = false;
		super.kill();
	}
	
}