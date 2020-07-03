package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;
import com.framework.utils.Random;

/**
 * ...
 * @author 
 */
class Gun extends Entity
{
	public var bulletsCollisions:CollisionGroup;
	public function new() 
	{
		super();
		pool=true;
		bulletsCollisions=new CollisionGroup();
	}
	public function shoot(aX:Float, aY:Float,dirX:Float,dirY:Float):Void
	{
		var bullet:Bullet=cast recycle(Bullet);
		var randomAngleY:Float = Random.getRandomIn(-0.05,0.05);
		bullet.shoot(aX,aY,dirX,randomAngleY,bulletsCollisions);
	}
	
}