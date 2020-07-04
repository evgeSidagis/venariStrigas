package gameObjects;

import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;

/**
 * ...
 * @author 
 */
class Bullet extends Entity
{
	public var collision:CollisionBox;
	var display:Sprite;
	var lifeTime:Float=0;
	var totalLifeTime:Float=3;

	public var damage: Int = 20;

	public function new() 
	{
		super();
		collision=new CollisionBox();
		collision.width=60;
		collision.height=10;
		collision.userData=this;

		display = new RectangleDisplay();
		display = new Sprite("bullet");
		display.scaleX=0.7;
		display.scaleY=0.7;

		display.offsetY = -40;
	}
	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
	}
	override function update(dt:Float) {
		lifeTime+=dt;
		if(lifeTime>totalLifeTime){
			die();
		}
		collision.update(dt);
		display.x=collision.x;
		display.y=collision.y;

		super.update(dt);
	}
	public function shoot(x:Float, y:Float,dirX:Float,dirY:Float,bulletsCollision:CollisionGroup):Void
	{
		lifeTime=0;
		collision.x=x;
		collision.y=y;
		collision.velocityX = 1500*dirX;
		collision.velocityY = 0;
		bulletsCollision.add(collision);
		GGD.simulationLayer.addChild(display);
		
	}
}