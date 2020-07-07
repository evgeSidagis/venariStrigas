package gameObjects;

import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;

/**
 * ...
 * @author 
 */
class Swing extends Entity
{
	public var collision:CollisionBox;
	var display:Sprite;
	var lifeTime:Float=0;
    var totalLifeTime:Float=1;
    var direction:FastVector2;

	public var damage: Int = 10;

	public function new() 
	{
		super();
		collision=new CollisionBox();
		collision.width=90;
		collision.height=90;
		collision.userData=this;

        direction=new FastVector2(1,0);
        
		display = new RectangleDisplay();
		display = new Sprite("Swing");
		display.scaleX=1;
		display.scaleY=1;

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
        
        if (direction.x < 0){
			display.scaleX  = -1;
			display.offsetX = 50;
		}else{
			display.scaleX  = 1;
			display.offsetX = 10;
		}
		super.update(dt);
	}
	public function swing(x:Float, y:Float,dirX:Float,dirY:Float,swordCollision:CollisionGroup):Void
	{
        lifeTime=0;
        if(dirX >= 0){
            collision.x=x+20;
        }else{
            collision.x=x-20;
        }
		collision.y=y;
		collision.velocityX = 0.1*dirX;
        collision.velocityY = 0;
        direction.setFrom(new FastVector2(collision.velocityX,collision.velocityY));
		direction.setFrom(direction.normalized());
		swordCollision.add(collision);
		GGD.simulationLayer.addChild(display);
	}
}