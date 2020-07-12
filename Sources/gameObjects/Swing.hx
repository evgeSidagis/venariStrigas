package gameObjects;

import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;

class Swing extends Entity
{
	public var collision:CollisionBox;
	var display:Sprite;
	var lifeTime:Float=0;
    var totalLifeTime:Float=1;
    var direction:FastVector2;

	public var damage: Int = 30;

	public function new() 
	{
		super();
		collision=new CollisionBox();
		collision.width=40;
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
		if(lifeTime>=totalLifeTime){
			die();
		}
		collision.update(dt);
		display.x=collision.x;
        display.y=collision.y;
        
        if (direction.x < 0){
			display.scaleX  = -1;
			display.offsetX = 100;
		}else{
			display.scaleX  = 1;
			display.offsetX = -70;
		}
		super.update(dt);
	}
	public function swing(x:Float, y:Float,dirX:Float,dirY:Float,swordCollision:CollisionGroup):Void
	{
        lifeTime=0;
        if(dirX >= 0){
            collision.x=x+80;
        }else{
            collision.x=x-40;
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