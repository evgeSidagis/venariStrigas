package gameObjects;

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
	var totalLifeTime:Float=2;

	var permanentDirX: Float = 0;
	var permanentDirY: Float = 0;

	public var damage: Int = 10;

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
		if(!GGD.isTimeStopped){
			lifeTime+=dt;
			if(lifeTime>totalLifeTime){
				die();
			}
			collision.update(dt);
			display.x=collision.x;
			display.y=collision.y;
		}
		super.update(dt);
	}
	public function shoot(x:Float, y:Float,dirX:Float,dirY:Float):Void
	{
		lifeTime=0;
		collision.x=x;
		collision.y=y;
		collision.velocityX = 500*dirX;
		collision.velocityY = 500*dirY;
		permanentDirX = dirX;
		permanentDirY = dirY;
		GGD.projectiles.add(collision);	
		GGD.simulationLayer.addChild(display);
		GGD.projectileList.push(this);
	}

	public function stopTimeline(){
		collision.velocityX = 0;
		collision.velocityY = 0;
	}

	public function resetTimeline(){
		collision.velocityX = 500*permanentDirX;
		collision.velocityY = 500*permanentDirY;
	}
}