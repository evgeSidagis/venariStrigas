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
	static private inline var SPEED:Float = 250;
	
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
	
	var isPreparingAttack: Bool = false;
	var isAttacking: Bool = false;
	var attackRespite: Int = 0;
	var attackCharge: Int = 60;

	var currentCharge: Int = 0;
	
	public function new(X:Float, Y:Float,layer:Layer, col:CollisionGroup) 
	{
		super();
        collisionGroup=col;

        health=30;

		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		
		dir=new FastVector2(1,0);
		display= new Sprite("meguca");
		display.timeline.playAnimation("Meguca_");
		display.timeline.frameRate=1/15;
		
        layer.addChild(display);
        
		collision=new CollisionBox();
		collision.width=80;
		collision.height=110;

		collision.userData=this;

		collision.x=X;
		collision.y=Y;

        col.add(collision);
	}
	override function update(dt:Float ):Void
	{
		//var target:Homura = GGD.player;
		

		if(isPreparingAttack){
			collision.velocityX = 0;
			currentCharge++;
		}
		if(currentCharge == attackCharge){
			isPreparingAttack = false;
			isAttacking = true;
			attackRespite++;
		}
		if(attackRespite == 1){
			attackRespite = 0;
			isAttacking = false;
			currentCharge = 0;
		}
		move();
	
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
		if(dir.x >= 0){
			display.scaleX= 1;
			display.offsetX= -10;
		}else{
			display.scaleX= -1;
			display.offsetX= 94;
		}
		super.render();
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

	inline function move(){
		if(!isAttacking && !isPreparingAttack){
			
			dir.setFrom(dir.normalized());
			dir.setFrom(dir.mult(SPEED));

			collision.velocityX=dir.x;
		}
	}
}