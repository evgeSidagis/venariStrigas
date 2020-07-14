package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;
import com.framework.utils.Random;

class Arm extends Entity
{
	public function new() 
	{
		super();
		pool=true;
	}
	public function shoot(aX:Float, aY:Float,dirX:Float,dirY:Float):Void
	{
		var projectile:Projectile=cast recycle(Projectile);
		projectile.shoot(aX,aY,dirX,dirY);
	}
}