package gameObjects;

import js.lib.Float32Array;
import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;

class Projectile extends Entity
{
	public var collision:CollisionBox;
	var display:Sprite;
	var lifeTime:Float=0;
	var totalLifeTime:Float=1;

	public var damage: Int = 40;

	public function new() 
	{
		super();
		collision=new CollisionBox();
		collision.width=10;
		collision.height=10;
		collision.userData=this;

		display = new RectangleDisplay();
		display = new Sprite("Proj");
		display.scaleX=0.1;
		display.scaleY=0.1;

		display.offsetY = 0;
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
	public function shoot(x:Float, y:Float,dirX:Float,dirY:Float):Void
	{
		lifeTime=0;
		collision.x=x;
		collision.y=y;
		collision.velocityX = 600*dirX;
		collision.velocityY = 600*dirY;
		GGD.projectiles.add(collision);
		GGD.simulationLayer.addChild(display);
	}
}