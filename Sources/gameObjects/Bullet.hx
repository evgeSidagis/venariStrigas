package gameObjects;

import js.lib.Float32Array;
import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;

class Bullet extends Entity
{
	public var collision:CollisionBox;
	var display:Sprite;
	var lifeTime:Float=0;
	var totalLifeTime:Float=1;
	var frameCheck: Float = 4;
	var framesExisting: Float = 0;

	var permanentDir: Float = 0;

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
		framesExisting++;
		if(!GGD.isTimeStopped || framesExisting <= frameCheck){
			lifeTime+=dt;
			if(lifeTime>=totalLifeTime){
				die();
			}
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
		collision.velocityX = 1500*dirX;
		permanentDir = dirX;
		collision.velocityY = 0;
		GGD.simulationLayer.addChild(display);
		GGD.bullets.add(collision);
		GGD.bulletList.push(this);
	}

	public function stopTimeline(){
		if(framesExisting > frameCheck){
			collision.velocityX = 0;
			collision.velocityY = 0;
		}
	}

	public function resetTimeline(){
		collision.velocityX = 1500*permanentDir;
	}
}