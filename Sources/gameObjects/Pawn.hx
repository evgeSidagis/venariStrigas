package gameObjects;

import com.gEngine.GEngine;
import gameObjects.Enemy;
import gameObjects.Sword;
import GlobalGameData.GGD;
import com.gEngine.display.Layer;
import com.framework.utils.Input;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;
import com.framework.utils.Entity;
import com.collision.platformer.Sides;
import com.collision.platformer.CollisionGroup;
import com.soundLib.SoundManager;

class Pawn extends Enemy
{
	static private inline var SPEED:Float = 250;
	
	var display:Sprite;
    public var collision:CollisionBox;
    public var collisionGroup:CollisionGroup;
	public var x(get,null):Float;
	public var y(get,null):Float;
	public var width(get,null):Float;
	public var height(get,null):Float;
	
	public var sword:Sword;
	public var dir:FastVector2;
	
	var screenWidth:Int;
	var screenHeight:Int;
	
	var canJump: Bool = true;
	
	var isPreparingAttack: Bool = false;
	var isAttacking: Bool = false;
	var attackRespite: Int = 0;
	var attackCharge: Int = 60;

	var currentCharge: Int = 0;
	var wasRunning: Bool = false;
	
	public function new(X:Float, Y:Float,layer:Layer, col:CollisionGroup) 
	{
		super();
		collisionGroup=col;
		health = 50 + 5*GGD.lap;

		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		
		dir=new FastVector2(1,0);
		display= new Sprite("pawn");
		display.timeline.playAnimation("stand_");
		display.timeline.frameRate=1/11;
		
        layer.addChild(display);
        
		collision=new CollisionBox();
		collision.width=80;
		collision.height=110;

		collision.userData=this;

		collision.x=X;
		collision.y=Y;

		collision.accelerationY = 2000;
		collision.maxVelocityX = 500;
		collision.maxVelocityY = 800;
		
		sword = new Sword();
		addChild(sword);

        col.add(collision);
	}
	override function update(dt:Float ):Void
	{
		var target:Homura = GGD.player;
		if(health>0 && !GGD.isTimeStopped){
			if(isPreparingAttack){
				collision.velocityX = 0;
				currentCharge++;
			}
			if(currentCharge == attackCharge){
				isPreparingAttack = false;
				isAttacking = true;
				sword.swing(collision.x,collision.y,dir.x,dir.y);
				SoundManager.playFx("swoosh",false);
				attackRespite++;
				currentCharge = 0;
			}
			if(attackRespite>0&&attackRespite<15){
				attackRespite++;
			}
			if(attackRespite == 15){
				attackRespite = 0;
				isAttacking = false;
			}
			if((target.y - collision.y <= 200 && target.y - collision.y >= -200) && 
				(target.x - collision.x <= 400 && target.x - collision.x >= -400) || health < 30)
			{
				move(target);
			}
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
	
		if(isAttacking){
			display.timeline.playAnimation("attack_");
			if(dir.x >=0){
				display.scaleX= 1;
				display.offsetX= -10;
			
			}else{
				display.scaleX= -1;
				display.offsetX= 94;
			}	
		}else if(notWalking() && !wasRunning){
			display.offsetY = 0;
			display.timeline.playAnimation("stand_");
			if(dir.x>=0){
				display.scaleX= 1;
				display.offsetX= -10;
			
			}else{
				display.scaleX= -1;
				display.offsetX= 94;
			}	
		}else{
			display.timeline.playAnimation("run_");
			if(dir.x >= 0){
				display.scaleX= 1;
				display.offsetX= -10;
			}else{
				display.scaleX= -1;
				display.offsetX= 94;
			}
		}
		super.render();
	}
	inline function notWalking(){
		return collision.velocityX==0 &&collision.velocityY==0;
    }
    
    override function damage(dmg: Int): Void {
        health -= dmg;
        if (health <= 0){
            collision.removeFromParent();
            display.removeFromParent();
        }
	}
	
	public function attack(){
		if (attackRespite == 0){
			isPreparingAttack = true;
		}
	}

	inline function move(target: Homura){
		if(!isAttacking && !isPreparingAttack){
			dir = new FastVector2(target.x-(collision.x+collision.width*0.5),0);

			dir.setFrom(dir.normalized());
			dir.setFrom(dir.mult(SPEED));

			collision.velocityX=dir.x;

			if(target.y < collision.y && canJump){
				collision.velocityY = -1000;
				canJump = false;
			}
			if(!isAttacking && collision.velocityY > 0 && canJump) {
				collision.velocityY = -1000;
				canJump = false;
			}
			if(!isAttacking && collision.velocityY == 0){
				canJump = true;
			}

		}
	}

	public function stopTimeline(){
		if(collision.velocityX !=0){
			wasRunning = true;
		}
		collision.accelerationY = 0;
		collision.velocityX = 0;
		collision.velocityY = 0;
		display.timeline.frameRate = 1/0;
	}

	public function resetTimeline(){
		wasRunning = false;
		collision.accelerationY = 2000;
		display.timeline.frameRate = 1/11;
	}
}