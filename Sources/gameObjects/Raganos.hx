package gameObjects;

import com.gEngine.GEngine;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;
import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.soundLib.SoundManager;

class Raganos extends Enemy
{
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

	var originX: Float;
	var originY: Float;

	var bossStage: Int = 1;

	var arm: Arm;

	var tripleShotTimer: Int = 0;
	var xAngle:Float = -1;
	var yAngle:Float = 0;
	var followCounter:Int = 0;

	var leftToRightX:Bool = true;
	var leftToRightY:Bool = true;
	
	public function new(X:Float, Y:Float,layer:Layer, col:CollisionGroup) 
	{
        health = 1250;
		super();
        collisionGroup = col;

		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		
		direction=new FastVector2(1,0);
		display= new Sprite("witch");
		display.timeline.playAnimation("witch_");
		display.timeline.frameRate=1/15;
        display.scaleX = 2;
        display.scaleY = 2;
	
		collision=new CollisionBox();
		collision.width= 244;
		collision.height= 220;

		collision.x=X;
        collision.y=Y;
        
		collision.userData=this;
		
		arm=new Arm();
		addChild(arm);

		col.add(collision);
		
		originX = X+collision.width/2;
		originY = Y+collision.height/2;

		layer.addChild(display);
	}
	override function update(dt:Float ):Void
	{
		if(health>0 && !GGD.isTimeStopped){
			tripleShotTimer++;
			checkStage();
			if(bossStage == 1){
				stageOneBehavior();
			}
			if(bossStage == 2){
				stageTwoBehavior();
			}
			if(bossStage == 3){
				stageThreeBehavior();
			}
		}

		collision.velocityX=0;
		collision.velocityY=0;
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
		super.render();
	}

	override function damage(dmg: Int): Void {
        health -= dmg;
        if (health <= 0){
            collision.removeFromParent();
            display.removeFromParent();
        }
	}

	

	function checkStage(){
		if (health<=750&&health>250){
			bossStage = 2;
		}
		if (health<=250){
			bossStage = 3;
		}
	}

	

	function stageOneBehavior(){
		if(tripleShotTimer % 180 == 0){
			tripleShotHorizontal(1);
			tripleShotHorizontal(-1);
			tripleShotVertical(1);
			tripleShotVertical(-1);
		}
	}

	function stageTwoBehavior(){
		followShot();
	}

	function stageThreeBehavior(){
		stageOneBehavior();
		stageTwoBehavior();
	}

	function tripleShotHorizontal(dirX: Float){
		arm.shoot(originX,originY,dirX,0);
		arm.shoot(originX,originY,dirX,0.5);
		arm.shoot(originX,originY,dirX,-0.5);
	}

	function tripleShotVertical(dirY: Float){
		arm.shoot(originX,originY,0,dirY);
		arm.shoot(originX,originY,0.5,dirY);
		arm.shoot(originX,originY,-0.5,dirY);
	}

	function followShot(){
		followCounter++;
		if(followCounter%7 == 0){
			arm.shoot(originX,originY,xAngle,yAngle);
			//SetDirectionsCorrectly
			if(xAngle >= 1){
				leftToRightX = false;
			}
			if(xAngle <= -1){
				leftToRightX = true;
			}
			if(yAngle >= 1){
				leftToRightY = true;
			}
			if(yAngle <= -1){
				leftToRightY = false;
			}
			if(leftToRightX){
				xAngle+=0.05;
			}else{
				xAngle-=0.05;
			}
			if(leftToRightY){
				yAngle-=0.05;
			}else{
				yAngle+=0.05;
			}
		}
	}

	public function stopTimeline(){
		collision.velocityX = 0;
		collision.velocityY = 0;
		display.timeline.frameRate = 1/0;
	}

	public function resetTimeline(){
		display.timeline.frameRate = 1/15;
	}
}