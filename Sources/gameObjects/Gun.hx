package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;
import com.framework.utils.Random;

class Gun extends Entity
{
	public function new() 
	{
		super();
		pool=true;
	}
	public function shoot(aX:Float, aY:Float,dirX:Float,dirY:Float):Void
	{
		var bullet:Bullet=cast recycle(Bullet);
		var randomAngleY:Float = Random.getRandomIn(-0.05,0.05);
		bullet.shoot(aX,aY,dirX,randomAngleY);
	}
}