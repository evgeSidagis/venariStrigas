import com.gEngine.display.Camera;
import com.gEngine.display.Layer;
import gameObjects.Homura;

typedef GGD = GlobalGameData; 
class GlobalGameData {

    public static var player:Homura;
    public static var simulationLayer:Layer;
    public static var camera:Camera;

    public static function destroy() {
        player=null;
        simulationLayer=null;
        camera=null;
    }
}