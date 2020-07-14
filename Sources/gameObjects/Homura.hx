package gameObjects;

import GlobalGameData.GGD;
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
import com.soundLib.SoundManager;


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

	public var health:Int = 100;

	var firstJump:Bool = false;
	var secondJump:Bool = false;

	var isAir: Bool = false;
	var jump: Int = 0;

	var isHurt: Bool = false;
	var hurtCounter: Int = 0;

	public var isNotAlive: Bool = false;

	public var controlEnabled: Bool = true;

	var returnControl: Int = 0;

	public var timeCounter: Int = 0;
	var playSpecialAnimation: Bool = false;
	var timeStopCooldown: Int = 1200 - 60*GGD.lap;

	var timeStopReady: Int = 0;

	public function new(X:Float, Y:Float,layer:Layer) 
	{
		super();
		
		if(timeStopCooldown<600){
			timeStopCooldown = 600;
		}

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
		checkAlive();
		checkTimeStopped();

		returnControl++;
		if(returnControl == 30){
			returnControl = 0;
			this.controlEnabled = true;
		}
		if(!isNotAlive && this.controlEnabled){
			collision.velocityX = 0;
			
			isOnAir();

			ifHurt();

			if(Input.i.isKeyCodeDown(KeyCode.Left)) {
				move(-SPEED);
			}
			if(Input.i.isKeyCodeDown(KeyCode.Right)){
				move(SPEED);
			}
			if(Input.i.isKeyCodePressed(KeyCode.Space) && shootingPistol != true && shootingRocket != true){
				beginJump();
			}
			if(collision.velocityX !=0){
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
			if(Input.i.isKeyCodePressed(KeyCode.X) && GGD.launcherEnabled){
				prepareRocket();
			}
			if(shootingRocket)
			{
				launchRocket();
			}
			if(Input.i.isKeyCodePressed(KeyCode.A) && timeStopReady == 0 && GGD.specialEnabled){
				specialAbility();
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
		
		if(isNotAlive){
			display.offsetY=0;
			display.timeline.playAnimation("dies_");	
			display.timeline.frameRate=1/10;
			if(direction.x >= 0){
				display.scaleX=1;
				display.offsetX= 0;
			
			}else{
				display.scaleX=-1;
				display.offsetX= 94;
			}
			display.timeline.frameRate=1/10;	
		}
		else if(shootingPistol == true)
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
		}else if(isHurt){
			display.offsetY=0;
			display.timeline.playAnimation("hurt_");	
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
		else if(playSpecialAnimation){
			display.timeline.playAnimation("spec_");
			if(direction.x>=0){
				display.scaleX= 1;
				display.offsetX= 0;
				display.offsetY = 4;
			}else{
				display.scaleX=- 1;
				display.offsetX= 94;
				display.offsetY = 4;
			}	
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

	public function beginJump(){
		var aux = 0;
		if(GGD.doubleJumpEnabled){
			aux = 2;
		}else{
			aux = 1;
		}
		if(this.jump < aux) {
			collision.velocityY=-750;
			this.jump++;
		}
	}

	inline function move(speed:Float){
		if (!playSpecialAnimation && !shootingPistol && !shootingRocket || this.isAir ){
			collision.velocityX = speed;
		}
	}

	inline function shootPistol(){
		if(pistolRecoil == 0 && rocketRecoil == 0){
			pistolRecoil++;
			shootingPistol = true;
			gun.shoot(x,y-height*0.65,display.scaleX, 0);
			SoundManager.playFx("gunshot2",false);
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
			SoundManager.playFx("rpg",false);
		}
		if(rocketRecoil == 45){
			rocketRecoil = 0;
			shootingRocket = false;
		}
	}

	inline function ifHurt(){
		if(isHurt){
			hurtCounter++;
		}
		if(hurtCounter >= 15){
			isHurt = false;
			hurtCounter == 0;
		}
	}

	public function damage(dmg: Int){
		isHurt = true;
		health -= dmg;
	}

	inline function checkAlive(){
		if (health<=0){
			collision.velocityX = 0;
			isNotAlive = true;
		}
	}

	inline function specialAbility(){
		timeStopReady = timeStopCooldown;
		GGD.isTimeStopped = true;
		playSpecialAnimation = true;
	}

	inline function checkTimeStopped(){
		if (timeStopReady > 0){
			timeStopReady--;
		}
		if(timeCounter == 30){
			playSpecialAnimation = false;
		}
		if(GGD.isTimeStopped){
			timeCounter++;
		}
		if(timeCounter >= GGD.timeStopDuration){
			GGD.isTimeStopped = false;
			timeCounter = 0;
		}
	}

	public function removeControl(){
		this.controlEnabled = false;
	};
}