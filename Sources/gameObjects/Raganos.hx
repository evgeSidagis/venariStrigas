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

	var bossStage: Int = 1;

	var arm: Arm;

	var tripleShotTimer: Int = 0;
	
	public function new(X:Float, Y:Float,layer:Layer, col:CollisionGroup) 
	{
        health = 1000;
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

		layer.addChild(display);
	}
	override function update(dt:Float ):Void
	{
		var target:Homura = GGD.player;
		tripleShotTimer++;
		if(bossStage == 1){
			if(tripleShotTimer == 180){
				tripleShotTimer = 0;
				arm.shoot(this.collision.x,this.collision.y+this.collision.y/2-30,-1,0);
				arm.shoot(this.collision.x,this.collision.y+this.collision.y/2-30,-1,1);
				arm.shoot(this.collision.x,this.collision.y+this.collision.y/2-30,-1,-1);
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
}
