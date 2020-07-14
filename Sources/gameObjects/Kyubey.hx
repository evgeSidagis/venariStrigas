package gameObjects;

import com.gEngine.GEngine;
import com.framework.Simulation;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;
import com.framework.utils.Entity;

class Kyubey extends Entity
{
	var direction:FastVector2;
	var display:Sprite;
	public var collision:CollisionBox;
	public var x(get,null):Float;
	public var y(get,null):Float;
	public var width(get,null):Float;
	public var height(get,null):Float;
	var screenWidth:Int;
	var screenHeight:Int;
	
	public function new(X:Float, Y:Float,layer:Layer) 
	{
		super();

		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		
		direction=new FastVector2(1,0);
		display= new Sprite("coobie");
		display.timeline.playAnimation("qb_");
		display.timeline.frameRate=1/15;
		
	
		collision=new CollisionBox();
		collision.width=46;
		collision.height=46;

		collision.x=X;
		collision.y=Y;

		layer.addChild(display);
	}
	override function update(dt:Float ):Void
	{
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

	public function changeDirection(){
		display.scaleX = -1;
	}
}