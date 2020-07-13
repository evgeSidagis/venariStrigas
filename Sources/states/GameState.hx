package states;

import kha.audio2.ResamplingAudioChannel;
import js.html.audio.ChannelMergerNode;
import com.collision.platformer.CollisionTileMap;
import com.loading.basicResources.FontLoader;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionBox;
import com.collision.platformer.CollisionGroup;
import com.loading.basicResources.ImageLoader;
import format.tmx.Data.TmxObjectType;
import com.gEngine.display.Sprite;
import com.gEngine.shaders.ShRetro;
import com.gEngine.shaders.ShBlurV;
import com.gEngine.shaders.ShBlurH;
import com.gEngine.display.Blend;
import com.gEngine.display.Camera;
import kha.Assets;
import com.gEngine.display.extra.TileMapDisplay;
import com.collision.platformer.Sides;
import com.framework.utils.XboxJoystick;
import com.framework.utils.VirtualGamepad;
import format.tmx.Data.TmxObject;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionEngine;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.GEngine;
import com.gEngine.display.Layer;
import com.loading.basicResources.DataLoader;
import com.loading.basicResources.SoundLoader;
import com.collision.platformer.Tilemap;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;
import cinematic.Doom;
import cinematic.Dialog;
import com.loading.basicResources.FontLoader;
import com.soundLib.SoundManager;
import com.gEngine.display.Text;
import gameObjects.Homura;
import gameObjects.Kyubey;
import gameObjects.Bullet;
import gameObjects.Rocket;
import gameObjects.Enemy;
import gameObjects.Pawn;
import gameObjects.Swing;
import gameObjects.Meguca;
import gameObjects.Raganos;
import gameObjects.Projectile;

import GlobalGameData.GGD;
import com.gEngine.display.StaticLayer;
import com.loading.basicResources.SparrowLoader;

class GameState extends State {
	var worldMap:Tilemap;
	var simulationLayer:Layer;

	var screenWidth:Int;
	var screenHeight:Int;

	var player:Homura;
	var raganos:Raganos;

	var backgroundLayer:Layer;
	var background:Sprite;
	
	//Displays
	var healthDisplay:Text;
	var bossDisplay:Text;
	var bossHealth: Int = 0;
	var health: Int = 100;
	var hudLayer: StaticLayer;
	var soulGem: Sprite;
	var pistolIcon:Sprite;
	var rocketIcon:Sprite;
	var specialIcon:Sprite;

	//enemyArrays
	var pawns: Array<Pawn> = new Array<Pawn>();
	var megucas: Array<Meguca> = new Array<Meguca>();
	var dialogCounter: Int = 1;

	//rooms
	var room : String;
	var fromRoom : String;
	var endings:CollisionGroup;

	//temporalSprites a purgar
	var temporalSprites: Array<Sprite> = new Array<Sprite>();
	var purgeSprites: Int = 0;
	
	//Collisions
	var teleportCollision: CollisionGroup;
	var bossCollision: CollisionGroup;
	var bullets: CollisionGroup;
	var rockets: CollisionGroup;
	var projectiles: CollisionGroup;
	var dialogCollision:CollisionGroup;
	var doomCollision: CollisionGroup;
	var enemyCollisions:CollisionGroup;
	var megucaCollisions:CollisionGroup;

	
	public function new(room:String, fromRoom:String = null) {
		super();
		this.room = room;
		this.fromRoom = fromRoom;
	}

	override function load(resources:Resources) {
		resources.add(new DataLoader(room+"_tmx"));
	
		var atlas = new JoinAtlas(2048, 2048);

		atlas.add(new TilesheetLoader("level1b", 32, 32, 0));
		atlas.add(new SparrowLoader("homurarpg", "homurarpg_xml"));
		atlas.add(new SparrowLoader("coobie", "coobie_xml"));
		atlas.add(new SparrowLoader("pawn","pawn_xml"));
		atlas.add(new SparrowLoader("meguca","meguca_xml"));
		atlas.add(new SparrowLoader("witch","witch_xml"));

		
		resources.add(new ImageLoader("bullet"));
		resources.add(new ImageLoader("rocket"));
		resources.add(new ImageLoader("FirstAreaDBg"));
		resources.add(new ImageLoader("SecondAreaDBg"));
		resources.add(new ImageLoader("BossAreaBg"));

		resources.add(new SoundLoader("FirstAreaDM",false));
		resources.add(new SoundLoader("SecondAreaDM",false));
		resources.add(new SoundLoader("BossAreaM",false));

		resources.add(new ImageLoader("gun_hit"));
		resources.add(new ImageLoader("blowing"));
		resources.add(new ImageLoader("Swing"));
		resources.add(new ImageLoader("Soulgem"));
		resources.add(new ImageLoader("Proj"));
		resources.add(new ImageLoader("PistolIcon"));
		resources.add(new ImageLoader("RocketIcon"));
		resources.add(new ImageLoader("SpecialIcon"));

		resources.add(new SoundLoader("gunshot2"));
		resources.add(new SoundLoader("swoosh"));
		resources.add(new SoundLoader("laugh2"));
		resources.add(new SoundLoader("rpg"));

		atlas.add(new FontLoader("Kenney_Pixel",24));
		atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName, 30));
		resources.add(atlas);
		
	}

	override function init() {

		backgroundLayer = new StaticLayer();
		background = new Sprite(room+"Bg");
		backgroundLayer.addChild(background);
		stage.addChild(backgroundLayer);
		SoundManager.playMusic(room+"M",true);


		stageColor(0.5, .5, 0.5);
		dialogCollision = new CollisionGroup();
		doomCollision = new CollisionGroup();
		enemyCollisions = new CollisionGroup();
		megucaCollisions = new CollisionGroup();
		bossCollision = new CollisionGroup();
		teleportCollision = new CollisionGroup();

		bullets = new CollisionGroup();
		rockets = new CollisionGroup();
		projectiles = new CollisionGroup();

		endings = new CollisionGroup();
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		worldMap = new Tilemap(room+"_tmx", 1);
		worldMap.init(function(layerTilemap, tileLayer) {
			if (!tileLayer.properties.exists("noCollision") && !tileLayer.properties.exists("cCol")) {
				layerTilemap.createCollisions(tileLayer);
			}
			var spr = new Sprite("level1b");
			var color:Int = tileLayer.tintColor;
			var red = (color & 0xFF0000) >> 16;
			var green = (color & 0x00FF00) >> 8;
			var blue = (color & 0x0000FF);
			spr.colorMultiplication(red/255,green/255,blue/255,1);

			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer,spr));
		}, parseMapObjects);
		
		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32 , worldMap.heightInTiles * 32);

		GGD.simulationLayer = simulationLayer;
		GGD.bullets = bullets;
		GGD.rockets = rockets;
		GGD.projectiles = projectiles;


		hudLayer = new StaticLayer();
		stage.addChild(hudLayer);
		healthDisplay=new Text(Assets.fonts.Kenney_ThickName);
		healthDisplay.x = GEngine.virtualWidth / 2;
		healthDisplay.y = 600;
		healthDisplay.text = Std.string(player.health);
		hudLayer.addChild(healthDisplay);
		
		soulGem = new Sprite("Soulgem");
		pistolIcon = new Sprite("PistolIcon");
		rocketIcon = new Sprite("RocketIcon");
		specialIcon = new Sprite("SpecialIcon");
		//setUpHealthIcon
		soulGem.x = GEngine.virtualWidth / 2 - 40;
		soulGem.y = 590;
		soulGem.scaleX = 2;
		soulGem.scaleY = 2;
		hudLayer.addChild(soulGem);

		//setUpPistolicon
		pistolIcon.x = 20;
		pistolIcon.y = 590;
		hudLayer.addChild(pistolIcon);
		//setUpRocketIcon
		rocketIcon.x = 80;
		rocketIcon.y = 590;
		//setUpSpecialIcon
		specialIcon.x = 140;
		specialIcon.y = 590;

		//setUpBossHealth
		if(raganos != null && raganos.health>0){
			bossDisplay=new Text(Assets.fonts.Kenney_ThickName);
			bossDisplay.x = GEngine.virtualWidth / 2;
			bossDisplay.y = 100;
			bossDisplay.text = Std.string(raganos.health);
			hudLayer.addChild(bossDisplay);
		}
	}


	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		switch (object.objectType){
			case OTRectangle:
				if(object.type=="dialog"){
					var text=object.properties.get("text");
					var id = object.id;
					var dialog=new Dialog(text,object.x,object.y,object.width,object.height,id);
					dialogCollision.add(dialog.collider);
					addChild(dialog);
				}
				if(object.type=="kyu"){
					var kyubey = new Kyubey(object.x-10,object.y,simulationLayer);
					addChild(kyubey);
				}
				if(object.type=="en"){
					var pawn = new Pawn(object.x,object.y,simulationLayer,enemyCollisions);
					enemyCollisions.add(pawn.collision);
					pawns.push(pawn);
					addChild(pawn);
				}
				if(object.type=="fen"){
					var meguca = new Meguca(object.x,object.y,simulationLayer,megucaCollisions);
					megucas.push(meguca);
					addChild(meguca);
				}
				if(object.type=="doom"){
					var doom = new Doom(object.x,object.y,object.width,object.height);
					doomCollision.add(doom.collider);
					addChild(doom);
				}
				if(object.type=="start"){
					if(player==null){
						player = new Homura(object.x,object.y, simulationLayer);
						addChild(player);
						GGD.player = player;
						
					}else{
						player.collision.x = object.x;
						player.collision.y = object.y;
					}
				}
				if(object.type=="end"){
					var end = new CollisionBox();
					end.x = object.x;
					end.y = object.y;
					end.width = object.width;
					end.height = object.height;
					end.userData = object.properties.get("goTo");
					endings.add(end);
				}
				if(object.type=="teleport"){
					var end = new CollisionBox();
					end.x = object.x;
					end.y = object.y;
					end.width = object.width;
					end.height = object.height;
					teleportCollision.add(end);
				}
				if(object.type == "boss"){
					raganos = new Raganos(object.x,object.y,simulationLayer,bossCollision);
					addChild(raganos); 
				}
			default:
		}
	}

	public function playerVsEnemy(a:ICollider,b:ICollider) {
		var pawn: Pawn = cast a.userData;
		pawn.attack();
		CollisionEngine.overlap(player.collision,pawn.sword.swordCollisions,playerVsSword);
	} 

	public function playerVsMeguca(a:ICollider, b:ICollider){
		var meguca: Meguca = cast a.userData;
		if(player.controlEnabled){
			player.removeControl();
			player.collision.velocityX = meguca.collision.velocityX;
			player.beginJump();
		}
	}

	inline function playerVsSword(a: ICollider, b: ICollider){
		var swing: Swing = cast a.userData;
		player.damage(swing.damage);
		health -= swing.damage;
		swing.die();
		healthDisplay.text = health + "";
	}

	inline function playerVsTeleport(a: ICollider, b:ICollider){
		player.collision.y = 20;
	}

	public function bulletVsEnemy(a:ICollider,b:ICollider) {
		var pawn: Pawn=cast b.userData;
		var bullet:Bullet=cast a.userData;

		pawn.damage(bullet.damage);
		bullet.die();

		var gunHit = new Sprite("gun_hit");
		gunHit.x = pawn.collision.x;
		gunHit.y = pawn.collision.y;
		
		temporalSprites.push(gunHit);
		simulationLayer.addChild(gunHit);
	}

	public function rocketVsEnemy(a:ICollider,b:ICollider) {
		var pawn: Pawn=cast b.userData;
		var rocket:Rocket=cast a.userData;

		pawn.damage(rocket.damage);
		rocket.die();

		var x: Float = pawn.collision.x;
		var y: Float = pawn.collision.y;
		
		var damagedPawns: Array<Pawn> = pawns.filter(function (f) return
			f.collision.x <= x+50 && f.collision.x >= x-50 &&
			f.collision.y <= y+50 && f.collision.y >= y-50);

		for (p in damagedPawns){
			p.damage(rocket.damage);
		}

		var explosion = new Sprite("blowing");
		explosion.x = pawn.collision.x;
		explosion.y = pawn.collision.y;
		temporalSprites.push(explosion);
		simulationLayer.addChild(explosion);
	}

	public function homuraVsEnd(a:ICollider,b:ICollider){
		if(Input.i.isKeyCodePressed(KeyCode.Return)){	
			if(a.userData != "endScreen"){
				SoundManager.stopMusic();
				changeState(new GameState(a.userData,room));
			}else{
				if(raganos==null||raganos.health<=0){
					SoundManager.stopMusic();
					GGD.lap++;
					changeState(new Ending());
				}
			}
		}
	}

	function dialogVsPlayer(dialogCollision:ICollider,collision:ICollider) {
		var dialog:Dialog=cast dialogCollision.userData;
		dialog.showText(simulationLayer);
		if(dialog.id == 1){
			GGD.doubleJumpEnabled = true;
		}
		if(dialog.id == 5){
			GGD.launcherEnabled = true;                                                            
		}
		if(dialog.id == 46){
			GGD.specialEnabled = true;
		}
	}

	function doomVsPlayer(doomCollision:ICollider, playerCollision:ICollider) {
		var doom:Doom=cast doomCollision.userData;
		doom.showText(simulationLayer);
		changeState(new GameOver());
	}

	public function bulletVsBoss(a:ICollider,b:ICollider) {
		var boss:Raganos=cast b.userData;
		var bullet:Bullet=cast a.userData;

		boss.damage(bullet.damage);
		bullet.die();

		var gunHit = new Sprite("gun_hit");
		gunHit.x = boss.collision.x;
		gunHit.y = boss.collision.y;
		
		temporalSprites.push(gunHit);
		simulationLayer.addChild(gunHit);
	}

	public function rocketVsBoss(a:ICollider,b:ICollider) {
		var boss:Raganos=cast b.userData;
		var rocket:Rocket=cast a.userData;

		boss.damage(rocket.damage);
		rocket.die();

		var x: Float = boss.collision.x;
		var y: Float = boss.collision.y;
		
		var explosion = new Sprite("blowing");
		explosion.x = boss.collision.x;
		explosion.y = boss.collision.y;
		temporalSprites.push(explosion);
		simulationLayer.addChild(explosion);
	}

	function playerVsProjectile(a:ICollider,b:ICollider){
		var projectile:Projectile = cast a.userData;
		player.damage(projectile.damage);
		projectile.die();
	}


	override function update(dt:Float) {
		super.update(dt);
		stage.defaultCamera().scale=1;
	
		CollisionEngine.collide(player.collision,worldMap.collision);
		CollisionEngine.collide(enemyCollisions,worldMap.collision);

		CollisionEngine.overlap(dialogCollision,player.collision,dialogVsPlayer);
		CollisionEngine.overlap(doomCollision,player.collision,doomVsPlayer);
		CollisionEngine.overlap(teleportCollision,player.collision,playerVsTeleport);
		
		CollisionEngine.overlap(GGD.rockets,enemyCollisions,rocketVsEnemy);
		CollisionEngine.overlap(GGD.bullets,enemyCollisions,bulletVsEnemy);
		
		CollisionEngine.overlap(player.collision,enemyCollisions,playerVsEnemy);
		CollisionEngine.overlap(player.collision,endings,homuraVsEnd);
		CollisionEngine.overlap(player.collision,megucaCollisions,playerVsMeguca);

		CollisionEngine.overlap(GGD.rockets, bossCollision, rocketVsBoss);
		CollisionEngine.overlap(GGD.bullets, bossCollision, bulletVsBoss);
		CollisionEngine.overlap(GGD.projectiles,player.collision,playerVsProjectile);

		stage.defaultCamera().setTarget(player.collision.x, player.collision.y);

		if(Input.i.isKeyCodePressed(KeyCode.R)){
            changeState(new Intro());
        }
		
		purgeSprites++;
		if(purgeSprites == 30){
			purgeSprites = 0;
			for(s in temporalSprites){
				s.removeFromParent();
			}
		}

		if(player.health <= 0 || player.collision.y > worldMap.heightInTiles * 32 + 200){
			changeState(new GameOver());
		}
		healthDisplay.text = player.health + "";
		if(raganos!=null){
			if(raganos.health>=0){
				bossDisplay.text = raganos.health + "";
			}else{
				bossDisplay.text = "0";
			}
		}

		if(GGD.launcherEnabled){
			hudLayer.addChild(rocketIcon);   
		}

		if(GGD.specialEnabled){
			hudLayer.addChild(specialIcon);
		}

		if(GGD.isTimeStopped){
			stopTime();
			stage.defaultCamera().postProcess=new ShRetro(Blend.blendDefault());
		}else{
			resumeTime();
			stage.defaultCamera().postProcess = null;
		}
	}

	function stopTime(){
		for(p in pawns){
			p.stopTimeline();
		}
		for(m in megucas){
			m.stopTimeline();
		}
		if(raganos!=null){
			raganos.stopTimeline();
		}
		for(b in GGD.bulletList){
			b.stopTimeline();
		}
		for(b in GGD.rocketList){
			b.stopTimeline();
		}
		for(b in GGD.projectileList){
			b.stopTimeline();
		}
	}

	function resumeTime(){
		for(p in pawns){
			p.resetTimeline();
		}
		for(m in megucas){
			m.resetTimeline();
		}
		if(raganos!=null){
			raganos.resetTimeline();
		}
		for(b in GGD.bulletList){
			b.resetTimeline();
		}
		for(b in GGD.projectileList){
			b.resetTimeline();
		}
		for(b in GGD.rocketList){
			b.resetTimeline();
		}

	}
	
	#if DEBUGDRAW
	/*override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera=stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer,camera);
	}*/
	#end
	override function destroy() {
		super.destroy();
	}
}
