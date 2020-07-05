package gameObjects;

import js.html.Directory;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;
import com.framework.utils.Random;

class Sword extends Entity
{
	public var swordCollisions:CollisionGroup;
	public function new() 
	{
		super();
		pool=true;
		swordCollisions=new CollisionGroup();
	}
	public function swing(aX:Float, aY:Float,dirX:Float,dirY:Float):Void
	{
        var swing:Swing=cast recycle(Swing);
		swing.swing(aX,aY,dirX,dirY,swordCollisions);
	}
}