import com.gEngine.display.Camera;
import com.gEngine.display.Layer;
import gameObjects.Homura;
import gameObjects.Bullet;
import gameObjects.Projectile;
import gameObjects.Rocket;
import com.collision.platformer.CollisionGroup;


typedef GGD = GlobalGameData; 
class GlobalGameData {

    public static var player:Homura;
    public static var simulationLayer:Layer;
    public static var camera:Camera;

    public static var bullets: CollisionGroup;
    public static var rockets: CollisionGroup;
    public static var projectiles: CollisionGroup;

    public static var launcherEnabled:Bool = false;
    public static var doubleJumpEnabled:Bool = false;
    public static var specialEnabled:Bool = false;

    public static var isTimeStopped:Bool = false;
    public static var timeStopDuration:Int = 240;

    public static var bulletList: Array<Bullet> = new Array<Bullet>();
    public static var rocketList: Array<Rocket> = new Array<Rocket>();
    public static var projectileList: Array<Projectile> = new Array<Projectile>();

    public static var lap: Int = 0;

    public static function destroy() {
        player=null;
        simulationLayer=null;
        camera=null;
    }
}