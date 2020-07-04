package gameObjects;

import com.gEngine.GEngine;
import com.framework.Simulation;
import gameObjects.Enemy;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;
import com.framework.utils.Entity;
import com.collision.platformer.Sides;
import com.collision.platformer.CollisionGroup;

class Pawn extends Entity
{
	static private inline var SPEED:Float = 250;
	
	var direction:FastVector2;
	var display:Sprite;
    public var collision:CollisionBox;
    public var collisionGroup:CollisionGroup;
	public var x(get,null):Float;
	public var y(get,null):Float;
	public var width(get,null):Float;
    public var height(get,null):Float;
    
	var screenWidth:Int;
    var screenHeight:Int;

    var health:Int = 50;
	
	public function new(X:Float, Y:Float,layer:Layer, col:CollisionGroup) 
	{
		super();
        collisionGroup=col;

		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		
		direction=new FastVector2(1,0);
		display= new Sprite("pawn");
		display.timeline.playAnimation("stand_");
		display.timeline.frameRate=1/11;
		
        layer.addChild(display);
        
		collision=new CollisionBox();
		collision.width=80;
		collision.height=110;

		collision.x=X;
		collision.y=Y;

		collision.accelerationY = 2000;
		collision.maxVelocityX = 500;
		collision.maxVelocityY = 800;

        col.add(collision);
	}
	override function update(dt:Float ):Void
	{
		collision.update(dt);
		super.update(dt);

	}
	public function get_x():Float{
		return collision.x+collision.width*0.5;
	}
	public function get_y():Float{
		return collision.y+collision.height;
	}
	public function get_width():Float{
		return collision.width;
	}
	public function get_height():Float{
		return collision.height;
	}

	
	override function render() {
		display.x=collision.x;
		display.y=collision.y;
	
		if(notWalking()){
			display.offsetY = 0;
			display.timeline.playAnimation("stand_");
			if(direction.x>=0){
				display.scaleX= 1;
				display.offsetX= -10;
			
			}else{
				display.scaleX=- 1;
				display.offsetX= 94;
			}	
		}else{
			display.timeline.playAnimation("run_");
			
			if(direction.x >= 0){
				display.scaleX=1;
				display.offsetY = 10;
				display.offsetX= -10;
			}else{
				display.scaleX=-1;
				display.offsetY = 10;
				display.offsetX= 94;
			}
		}
		super.render();
	}
	inline function walking45() {
		return direction.x!=0 && direction.y!=0;
	}
	inline function notWalking(){
		return collision.velocityX==0 &&collision.velocityY==0;
    }
    
    public function damage(dmg: Int): Void {
        health -= dmg;
        if (health <= 0){
            collision.removeFromParent();
            display.removeFromParent();
        }
    }
}