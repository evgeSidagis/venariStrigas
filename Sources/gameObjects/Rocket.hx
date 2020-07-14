package gameObjects;

import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;

class Rocket extends Entity
{
	public var collision:CollisionBox;
	var display:Sprite;
	var lifeTime:Float=0;
	var totalLifeTime:Float=1;
	var direction:FastVector2;
	
	public var damage:Int = 50;
	public var radius:Int = 50;
	var permanentDir: Float = 0;

	var frameCheck: Float = 4;
	var framesExisting: Float = 0;

	public function new() 
	{
		super();
		collision=new CollisionBox();
		collision.width=60;
		collision.height=10;
		collision.userData=this;
		direction=new FastVector2(1,0);

		display = new Sprite("rocket");
		display.scaleX=0.7;
		display.scaleY=0.7;

		display.offsetX = 10;
		display.offsetY = -10;
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
			if (direction.x < 0){
				display.scaleX  = -0.7;
				display.offsetX = 50;
			}else{
				display.scaleX  = 0.7;
				display.offsetX = 10;
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
		setProperStartPoint(x,dirX);
		collision.y=y;
		collision.velocityX = 1000*dirX;
		permanentDir = dirX;
		collision.velocityY = 0;
		direction.setFrom(new FastVector2(collision.velocityX,collision.velocityY));
		direction.setFrom(direction.normalized());
		GGD.simulationLayer.addChild(display);
		GGD.rockets.add(collision);
		GGD.rocketList.push(this);
	}

	public function stopTimeline(){
		if(framesExisting>frameCheck){
			collision.velocityX = 0;
			collision.velocityY = 0;
		}
	}

	public function resetTimeline(){
		collision.velocityX = 1000*permanentDir;
	}

	inline function setProperStartPoint(x:Float,dirX: Float){
		if(dirX==1){
			collision.x=x;
		}else{
			collision.x=x-60;
		}
	}
}