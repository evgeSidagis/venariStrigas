package gameObjects;

import kha.FastFloat;
import com.gEngine.GEngine;
import kha.math.FastVector2;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;

class Ball extends Entity {

    public var x(get,null):Float;
    public var y(get,null):Float;
    public var radio(get,null):Float;
    private static inline var gravity:Float = 2000;
    var screenWidth:Int;
    var screenHeight:Int;
    var coffinDance:Bool;
    public var isBoss:Bool;
    var aux:FastFloat;

    var ball:Sprite;
    public var collision:CollisionBox;
    var collisionGroup:CollisionGroup;
    
    public function new(layer:Layer, x:Float, y:Float, radi:Float,col:CollisionGroup, vx:Float, vy:Float,boss:Bool){
        super();
        collisionGroup=col;
        radio = radi;
        coffinDance = false;
        
        isBoss = boss;

        //radios pelota 40: Mas grande, 20 medio, 10, chico, 5, minima. (Boss)
        //escalas         2                1        0.5          0.25
        var realScale = 0.25;
        ball = new Sprite("Hydra");
        if(isBoss==false){
            ball.colorMultiplication(Math.random(),Math.random(),Math.random());
        }else
        {
            ball.colorMultiplication(255,255,255);
        }
        if (radio == 40){
            realScale = 2;
        }
        if (radio == 20){
            realScale = 1;
        }
        if (radio == 10){
            realScale = 0.5;
        }
        if(radio == 5)
        {
            realScale = 0.25;
        }
        if(radio == 2.5)
        {
            realScale = 0.125;
        }
        
        ball.scaleX = realScale; 
        ball.scaleY = realScale;
        layer.addChild(ball);
        
        collision=new CollisionBox();

		collision.width  = radio*2;
		collision.height = radio*2;
        collision.userData=this;
        collision.x=x;
        collision.y=y;

        collision.velocityX=vx;
        collision.velocityY=vy;

        screenWidth = GEngine.i.width;
        screenHeight = GEngine.i.height;

        col.add(collision);
    }

    override function update(dt:Float){

        collision.x += collision.velocityX*dt; 
        collision.y += collision.velocityY*dt; //+ (1/2)*gravity*dt;
        ball.x=collision.x;
        ball.y=collision.y;

        if(collision.x-radio<=0||collision.x+radio>screenWidth-50){
           collision.velocityX*=-1;
        }    

        if(collision.y+radio>=640 && collision.velocityY>=0){
            collision.velocityY*=-1;
        }
        if(collision.y-radio<0 && collision.velocityY <= 0)
        {
            collision.velocityY*=-1;
        }

        collision.update(dt);
        super.update(dt);
    }

    public function get_x():Float{
		return collision.x;
	}
	public function get_y():Float{
		return collision.y;
	}
	public function get_radio():Float{
		return radio;
    }
    
    public function damage():Void{   
        collision.removeFromParent();
        ball.removeFromParent();
    }
    
    override function render(){
        ball.x = collision.x;
        ball.y = collision.y;
        super.render();
    }

}