package states;

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
import com.gEngine.shaders.ShFilmGrain;
import com.gEngine.display.Blend;
import com.gEngine.shaders.ShRgbSplit;
import com.gEngine.display.Camera;
import kha.Assets;
import helpers.Tray;
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
import gameObjects.Ball;
import gameObjects.Rocket;
import gameObjects.Enemy;
import gameObjects.Pawn;
import gameObjects.Swing;
import gameObjects.Meguca;

import GlobalGameData.GGD;
import com.gEngine.display.StaticLayer;
import com.loading.basicResources.SparrowLoader;

class GameState extends State {
	var worldMap:Tilemap;
	var simulationLayer:Layer;
	var touchJoystick:VirtualGamepad;
	var dialogCollision:CollisionGroup;
	var doomCollision: CollisionGroup;
	var screenWidth:Int;
	var screenHeight:Int;
	var player:Homura;
	var backgroundLayer:Layer;
	var background:Sprite;
	var enemyCollisions:CollisionGroup;
	var megucaCollisions:CollisionGroup;
	
	var scoreDisplay:Text;
	var score: Int = 0;
	var healthDisplay:Text;
	var health: Int = 100;
	var hudLayer: StaticLayer;
	var soulGem: Sprite;
	var kyubey: Kyubey;

	
	
	var gunHit: Sprite;
	var playGunHit: Bool = false;
	var gunHitDuration: Int = 1;
	var playAnimHit: Int = 0;

	var explosion: Sprite;
	var playexplosion: Bool = false;
	var explosionDuration: Int = 3;
	var playExplosionWhile: Int = 0;

	var pawns: Array<Pawn> = new Array<Pawn>();
	var dialogCounter: Int = 1;
	
	public function new(room:String, fromRoom:String = null) {
		super();
	}

	override function load(resources:Resources) {
		resources.add(new DataLoader(Assets.blobs.FirstAreaD_tmxName));
		resources.add(new DataLoader(Assets.blobs.SecondAreaD_tmxName));
		var atlas = new JoinAtlas(2048, 2048);

		atlas.add(new TilesheetLoader("level1b", 32, 32, 0));
		atlas.add(new SparrowLoader("homurarpg", "homurarpg_xml"));
		atlas.add(new SparrowLoader("coobie", "coobie_xml"));
		atlas.add(new SparrowLoader("pawn","pawn_xml"));
		atlas.add(new SparrowLoader("meguca","meguca_xml"));
		resources.add(new ImageLoader("Hydra"));
		resources.add(new ImageLoader("bullet"));
		resources.add(new ImageLoader("rocket"));
		resources.add(new ImageLoader("darkBg1"));
		resources.add(new ImageLoader("city2"));
		resources.add(new ImageLoader("gun_hit"));
		resources.add(new ImageLoader("blowing"));
		resources.add(new ImageLoader("Swing"));
		resources.add(new ImageLoader("Soulgem"));
		resources.add(new SoundLoader("Decretum"));

		atlas.add(new FontLoader("Kenney_Pixel",24));
		atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName, 30));
		resources.add(atlas);
	}

	override function init() {

		backgroundLayer = new StaticLayer();
		background = new Sprite("darkBg1");
		backgroundLayer.addChild(background);
		stage.addChild(backgroundLayer);
		SoundManager.playMusic("Decretum",true);

		stageColor(0.5, .5, 0.5);
		dialogCollision = new CollisionGroup();
		doomCollision = new CollisionGroup();
		enemyCollisions = new CollisionGroup();
		megucaCollisions = new CollisionGroup();
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		worldMap = new Tilemap("FirstAreaD_tmx", 1);
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

		//player = new Homura(100,200, simulationLayer);
		
		//addChild(player);
		
		//GGD.player = player;
		GGD.simulationLayer = simulationLayer;


		hudLayer = new StaticLayer(); // layer independent from the camera psition
		stage.addChild(hudLayer);
		scoreDisplay = new Text(Assets.fonts.Kenney_ThickName);
		scoreDisplay.x = GEngine.virtualWidth / 2;
		scoreDisplay.y = 30;
		hudLayer.addChild(scoreDisplay);
		scoreDisplay.text = "0";
		healthDisplay=new Text(Assets.fonts.Kenney_ThickName);
		healthDisplay.x = GEngine.virtualWidth / 2;
		healthDisplay.y = 600;
		healthDisplay.text = Std.string(player.health);
		hudLayer.addChild(healthDisplay);
		
		soulGem = new Sprite("Soulgem");
		soulGem.x = GEngine.virtualWidth / 2 - 40;
		soulGem.y = 600 - 10;
		soulGem.scaleX = 2;
		soulGem.scaleY = 2;
		hudLayer.addChild(soulGem);
	}


	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		switch (object.objectType){
			case OTRectangle:
				if(object.type=="dialog"){
					var text=object.properties.get("text");
					var dialog=new Dialog(text,object.x,object.y,object.width,object.height,dialogCounter++);
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
					addChild(meguca);
				}
				if(object.type=="doom"){
					var doom = new Doom(object.x,object.y,object.width,object.height);
					doomCollision.add(doom.collider);
					addChild(doom);
				}
				if(object.type=="start"){
					player = new Homura(object.x,object.y, simulationLayer);
					addChild(player);
					GGD.player = player;
				}
				if(object.type=="end"){
					//DoSomething();
				}
			default:
		}
	}

	public function playerVsEnemy(a:ICollider,b:ICollider) {
		var pawn: Pawn = cast a.userData;
		pawn.attack();
		CollisionEngine.overlap(player.collision,pawn.sword.swordCollisions,playerVsSword);
	} 

	inline function playerVsSword(a: ICollider, b: ICollider){
		var swing: Swing = cast a.userData;
		player.damage(swing.damage);
		health -= swing.damage;
		swing.die();
		healthDisplay.text = health + "";
	}

	public function bulletVsEnemy(a:ICollider,b:ICollider) {
		var pawn: Pawn=cast b.userData;
		var bullet:Bullet=cast a.userData;

		pawn.damage(bullet.damage);
		bullet.die();

		gunHit = new Sprite("gun_hit");
		gunHit.x = pawn.collision.x;
		gunHit.y = pawn.collision.y;
		
		simulationLayer.addChild(gunHit);
		playGunHit = true;
		
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

		explosion = new Sprite("blowing");
		explosion.x = pawn.collision.x;
		explosion.y = pawn.collision.y;
		
		simulationLayer.addChild(explosion);
		playexplosion = true;
	}

	override function update(dt:Float) {
		super.update(dt);
		stage.defaultCamera().scale=1;
	
		CollisionEngine.collide(player.collision,worldMap.collision);
		CollisionEngine.collide(enemyCollisions,worldMap.collision);

		CollisionEngine.overlap(dialogCollision,player.collision,dialogVsPlayer);
		CollisionEngine.overlap(doomCollision,player.collision,doomVsPlayer);
		
		CollisionEngine.overlap(player.rocketLauncher.rocketCollisions,enemyCollisions,rocketVsEnemy);
		CollisionEngine.overlap(player.gun.bulletsCollisions,enemyCollisions,bulletVsEnemy);
		
		CollisionEngine.overlap(player.collision,enemyCollisions,playerVsEnemy);

		stage.defaultCamera().setTarget(player.collision.x, player.collision.y);

		if (Input.i.isKeyCodePressed(KeyCode.Return)) {
			changeState(new GameOver(score + ""));
		}
		

		if(playGunHit){
			playAnimHit++;
			if(playAnimHit == gunHitDuration){
				playGunHit = false;
				playAnimHit = 0;
				gunHit.removeFromParent();
				gunHit.removeFromParent();
				gunHit.removeFromParent();
			}
		}
		if(playexplosion){
			playExplosionWhile++;
			if(playExplosionWhile == explosionDuration){
				playexplosion = false;
				playExplosionWhile = 0;
				explosion.removeFromParent();
				explosion.removeFromParent();
				explosion.removeFromParent();
			}
		}
		
	}
	function dialogVsPlayer(dialogCollision:ICollider,collision:ICollider) {
		var dialog:Dialog=cast dialogCollision.userData;
		dialog.showText(simulationLayer);
		if(dialog.id == 1){
			player.enableDoubleJump();
		}
		if(dialog.id == 2){
			player.enableRocket();                                                                             
		}
	}

	function doomVsPlayer(doomCollision:ICollider, playerCollision:ICollider) {
		var doom:Doom=cast doomCollision.userData;
		doom.showText(simulationLayer);
	}
	
	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera=stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer,camera);
	}
	#end
	override function destroy() {
		super.destroy();
	}
}
