package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;
import com.framework.utils.Random;

/**
 * ...
 * @author 
 */
class RocketLauncher extends Entity
{
	public var rocketCollisions:CollisionGroup;
	public function new() 
	{
		super();
		pool=true;
		rocketCollisions=new CollisionGroup();
	}
	public function shoot(aX:Float, aY:Float,dirX:Float,dirY:Float):Void
	{
        var rocket:Rocket=cast recycle(Rocket);
        var randomAngleY:Float = Random.getRandomIn(-0.05,0.05);
		rocket.shoot(aX,aY,dirX,randomAngleY,rocketCollisions);
	}
	
}