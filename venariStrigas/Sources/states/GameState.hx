package states;

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
import gameObjects.ChivitoBoy;
import com.loading.basicResources.TilesheetLoader;
import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.display.Layer;
import com.loading.basicResources.DataLoader;
import com.collision.platformer.Tilemap;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;
import cinematic.Dialog;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Text;
import gameObjects.Homura;
import gameObjects.Kyubey;
import gameObjects.Bullet;
import gameObjects.Ball;
import gameObjects.Rocket;
import GlobalGameData.GGD;
import com.gEngine.display.StaticLayer;
import com.loading.basicResources.SparrowLoader;

class GameState extends State {
	var worldMap:Tilemap;
	var chivito:ChivitoBoy;
	var simulationLayer:Layer;
	var touchJoystick:VirtualGamepad;
	var dialogCollision:CollisionGroup;
	var screenWidth:Int;
	var screenHeight:Int;
	var player:Homura;
	var backgroundLayer:Layer;
	var background:Sprite;
	var enemyCollisions:CollisionGroup;
	var scoreDisplay:Text;
	var score:Int = 0;
	var hudLayer:StaticLayer;
	
	

	var kyubey:Kyubey;

	var spawner:Int = 0;


	public function new(room:String, fromRoom:String = null) {
		super();
	}

	override function load(resources:Resources) {
		resources.add(new DataLoader(Assets.blobs.FirstAreaD_tmxName));
		var atlas = new JoinAtlas(2048, 2048);

		atlas.add(new TilesheetLoader("level1b", 32, 32, 0));
		atlas.add(new SparrowLoader("homurarpg", "homurarpg_xml"));
		atlas.add(new SparrowLoader("coobie", "coobie_xml"));
		resources.add(new ImageLoader("Hydra"));
		resources.add(new ImageLoader("bullet"));
		resources.add(new ImageLoader("rocket"));
		resources.add(new ImageLoader("darkBg1"));

		atlas.add(new FontLoader("Kenney_Pixel",24));
		resources.add(atlas);
	}

	override function init() {

		backgroundLayer = new Layer();
		background = new Sprite("darkBg1");
		backgroundLayer.addChild(background);
		stage.addChild(backgroundLayer);

		stageColor(0.5, .5, 0.5);
		dialogCollision = new CollisionGroup();
		enemyCollisions = new CollisionGroup();
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		worldMap = new Tilemap("FirstAreaD_tmx", 1);
		worldMap.init(function(layerTilemap, tileLayer) {
			if (!tileLayer.properties.exists("noCollision") && !tileLayer.properties.exists("cCol")) {
				layerTilemap.createCollisions(tileLayer);
			}
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer,new Sprite("level1b")));
		}, parseMapObjects);
		
		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32 , worldMap.heightInTiles * 32);

		player = new Homura(100,1200, simulationLayer);
		
		addChild(player);

		//createTouchJoystick();
		
		GGD.player = player;
		GGD.simulationLayer = simulationLayer;

		//stage.defaultCamera().postProcess=new ShFilmGrain(Blend.blendDefault());
	}

	/*function createTouchJoystick() {
		touchJoystick = new VirtualGamepad();
		touchJoystick.addKeyButton(XboxJoystick.LEFT_DPAD, KeyCode.Left);
		touchJoystick.addKeyButton(XboxJoystick.RIGHT_DPAD, KeyCode.Right);
		touchJoystick.addKeyButton(XboxJoystick.UP_DPAD, KeyCode.Up);
		touchJoystick.addKeyButton(XboxJoystick.A, KeyCode.Space);
		touchJoystick.addKeyButton(XboxJoystick.X, KeyCode.X);
		touchJoystick.notify(chivito.onAxisChange, chivito.onButtonChange);

		var gamepad = Input.i.getGamepad(0);
		gamepad.notify(chivito.onAxisChange, chivito.onButtonChange);
		
	}
*/

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		switch (object.objectType){
			case OTTile(gid):
				var kyubey = new Kyubey(object.x-60,object.y-50,simulationLayer);
				addChild(kyubey);
			case OTRectangle:
				if(object.type=="dialog"){
					var text=object.properties.get("text");
					var dialog=new Dialog(text,object.x,object.y,object.width,object.height);
					dialogCollision.add(dialog.collider);
					addChild(dialog);
				}
			default:
		}
	}

	public function playerVsBalls(a:ICollider,b:ICollider) {
		//SoundManager.stopMusic();
		changeState(new GameOver(score+""));
	} 
	public function bulletVsBall(a:ICollider,b:ICollider) {
		var ball:Ball=cast b.userData;
		ball.damage();
		var bullet:Bullet=cast a.userData;
		bullet.die();
		scoreDisplay.text=score+"";
	}

	override function update(dt:Float) {
		super.update(dt);
		stage.defaultCamera().scale=1;
	
		CollisionEngine.collide(player.collision,worldMap.collision);
		CollisionEngine.overlap(dialogCollision,player.collision,dialogVsPlayer);
		stage.defaultCamera().setTarget(player.collision.x, player.collision.y);

		CollisionEngine.overlap(player.rocketLauncher.rocketCollisions,enemyCollisions,bulletVsBall);
		CollisionEngine.overlap(player.gun.bulletsCollisions,enemyCollisions,bulletVsBall);
		CollisionEngine.overlap(player.collision,enemyCollisions,playerVsBalls);
		
		if (Input.i.isKeyCodePressed(KeyCode.Return)) {
			changeState(new GameOver(score + ""));
        }

	}
	function dialogVsPlayer(dialogCollision:ICollider,chivitoCollision:ICollider) {
		var dialog:Dialog=cast dialogCollision.userData;
		dialog.showText(simulationLayer);
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
		touchJoystick.destroy();
	}

}
