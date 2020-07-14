package gameObjects;

import com.gEngine.GEngine;
import com.framework.Simulation;
import gameObjects.Enemy;
import GlobalGameData.GGD;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;
import com.framework.utils.Entity;
import com.collision.platformer.Sides;
import com.collision.platformer.CollisionGroup;

class Meguca extends Enemy
{
	static private inline var SPEED:Float = 300;
	
	var display:Sprite;
    public var collision:CollisionBox;
    public var collisionGroup:CollisionGroup;
	public var x(get,null):Float;
	public var y(get,null):Float;
	public var width(get,null):Float;
	public var height(get,null):Float;
	
	public var dir:FastVector2;
	
	var screenWidth:Int;
	var screenHeight:Int;

	var changeDirection: Int = 90;

	var changeCounter = 0;

	var oldDirection: Float = 0;
	
	public function new(X:Float, Y:Float,layer:Layer, col:CollisionGroup) 
	{
		super();
        collisionGroup=col;

        health=1;

		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		
		dir=new FastVector2(1,0);
		display= new Sprite("meguca");
		display.timeline.playAnimation("Meguca_");
		display.timeline.frameRate=1/15;
		display.scaleX = 0.5;
		display.scaleY = 0.5;
		
        layer.addChild(display);
        
		collision=new CollisionBox();
		collision.width=40;
		collision.height=40;

		collision.userData=this;

		collision.x=X;
		collision.y=Y;

		collision.velocityX = SPEED;

		oldDirection = collision.velocityX;

        col.add(collision);
	}
	override function update(dt:Float ):Void
	{
		if(!GGD.isTimeStopped){
			move();
		}
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
		display.timeline.playAnimation("Meguca_");	
		if(oldDirection == SPEED){
			display.scaleX= 0.5;
			display.offsetX= 0;
		}else{
			display.scaleX= -0.5;
			display.offsetX= 47;
		}
		super.render();
	}
    
	inline function move(){
		changeCounter++;
		if(changeDirection == changeCounter){
			collision.velocityX= collision.velocityX*-1;
			oldDirection = collision.velocityX;
			changeCounter = 0;
		}
	}

	public function stopTimeline(){
		if(collision.velocityX !=0){
			oldDirection = collision.velocityX;
		}
		collision.velocityX = 0;
		display.timeline.frameRate = 1/0;
	}

	public function resetTimeline(){
		collision.velocityX = oldDirection;
		if(oldDirection == 0){
			oldDirection = SPEED;
		}
		display.timeline.frameRate = 1/10;
	}
}