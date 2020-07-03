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
import com.collision.platformer.Sides;


/**
 * ...
 * @author 
 */
class Homura extends Entity
{
	static private inline var SPEED:Float = 500;
	
	public var gun:Gun;
	public var rocketLauncher:RocketLauncher;

	var direction:FastVector2;
	var display:Sprite;
	public var collision:CollisionBox;
	public var x(get,null):Float;
	public var y(get,null):Float;
	public var width(get,null):Float;
	public var height(get,null):Float;
	var shootingPistol:Bool;
	var screenWidth:Int;
	var screenHeight:Int;
	var spawner:Int = 0;
	var pistolRecoil:Int = 0;
	var rocketRecoil:Int = 0;
	var shootingRocket:Bool;

	var firstJump:Bool = false;
	var secondJump:Bool = false;

	var isAir: Bool = false;
	var jump: Int = 0;
	
	public function new(X:Float, Y:Float,layer:Layer) 
	{
		super();

		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		
		direction=new FastVector2(1,0);
		display= new Sprite("homurarpg");
		display.timeline.playAnimation("idle_");
		display.timeline.frameRate=1/15;
		
	
		collision=new CollisionBox();
		collision.width=80;
		collision.height=110;

		collision.x=X;
		collision.y=Y;

		collision.accelerationY = 2000;
		collision.maxVelocityX = 500;
		collision.maxVelocityY = 800;

		layer.addChild(display);
		
		gun=new Gun();
		addChild(gun);
		display.smooth=false;

		rocketLauncher = new RocketLauncher();
		addChild(rocketLauncher);
		display.smooth = false;
		

		shootingPistol = false;
		pistolRecoil = 0;
		shootingRocket = false;
		rocketRecoil = 0;
	}
	override function update(dt:Float ):Void
	{
		collision.velocityX = 0;
		isOnAir();

		if(Input.i.isKeyCodeDown(KeyCode.Left)) {
			move(-SPEED);
		}
		if(Input.i.isKeyCodeDown(KeyCode.Right)){
			move(SPEED);
		}
		if(Input.i.isKeyCodePressed(KeyCode.Space) && shootingPistol != true && shootingRocket != true){
			beginJump();
		}
		if(collision.velocityX !=0 || collision.velocityY !=0){
			direction.setFrom(new FastVector2(collision.velocityX,collision.velocityY));
			direction.setFrom(direction.normalized());
		}else{
			direction.y=-1;
		}

		if(Input.i.isKeyCodePressed(KeyCode.Z)){
			shootPistol();
		}
		if(shootingPistol)
		{ 
			recoilPistol();
		}
		if(Input.i.isKeyCodePressed(KeyCode.X)){
			prepareRocket();
		}
		if(shootingRocket)
		{
			launchRocket();
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
	
		if(shootingPistol == true)
		{	
			display.offsetY=0;
			display.timeline.playAnimation("gun_");	
			display.timeline.frameRate=1/30;
			if(direction.x >= 0){
				display.scaleX=1;
				display.offsetX= 0;
			
			}else{
				display.scaleX=-1;
				display.offsetX= 94;
			}
			display.timeline.frameRate=1/15;		
		}
		else if(shootingRocket == true){	
				display.offsetY=0;
				display.timeline.playAnimation("rpg_");	
				display.timeline.frameRate=1/30;
				if(direction.x >= 0){
					display.scaleX=1;
					display.offsetX= -20;
				
				}else{
					display.scaleX=-1;
					display.offsetX= 110;
				}
				display.timeline.frameRate=1/15;		
		}
		else if(notWalking()){
			display.offsetY = 0;
			display.timeline.playAnimation("idle_");
			if(direction.x>=0){
				display.scaleX= 1;
				display.offsetX= 0;
			
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

	inline function isOnAir(){
		if (collision.isTouching(Sides.BOTTOM)){
			this.isAir = false;
			this.jump = 0;
		}else{
			this.isAir = true;
		}
	}

	inline function beginJump(){
		if(this.jump < 2) {
			collision.velocityY=-750;
			this.jump++;
		}
	}

	inline function move(speed:Float){
		if (shootingPistol != true && shootingRocket != true || this.isAir){
			collision.velocityX = speed;
		}
	}

	inline function shootPistol(){
		if(pistolRecoil == 0 && rocketRecoil == 0){
			pistolRecoil++;
			shootingPistol = true;
			gun.shoot(x,y-height*0.65,display.scaleX, 0);
		}
	}
	inline function recoilPistol(){
		pistolRecoil++;
		if(pistolRecoil == 15){
			pistolRecoil = 0;
			shootingPistol = false;
		}
	}	
	
	inline function prepareRocket(){
		if(rocketRecoil == 0 && pistolRecoil == 0){
			rocketRecoil++;
			shootingRocket = true;
		}
	}

	
	inline function launchRocket(){
		rocketRecoil++;
		if(rocketRecoil == 30){
			rocketLauncher.shoot(x,y-height*0.70,display.scaleX,0);
		}
		if(rocketRecoil == 45){
			rocketRecoil = 0;
			shootingRocket = false;
		}
	}
}