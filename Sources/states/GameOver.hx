package states;

import com.gEngine.display.Sprite;
import kha.Color;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.display.StaticLayer;
import com.gEngine.GEngine;
import com.gEngine.display.Text;
import kha.Assets;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import kha.math.FastVector2;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class GameOver extends State {
    var message:String;
    public function new(message:String="") {
        super();
        this.message=message;
    }
    override function load(resources:Resources) {
        var atlas:JoinAtlas=new JoinAtlas(1024,1024);
        atlas.add(new ImageLoader("gameOver"));
        atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName,30));
        resources.add(atlas);
    }

    override function init() {
        var image=new Sprite("gameOver");
        image.x=GEngine.virtualWidth*0.5-image.width()*0.5;
        image.y=100;
        stage.addChild(image);
        var scoreDisplay=new Text(Assets.fonts.Kenney_ThickName);
        scoreDisplay.text="You have failed in your quest to find Madoka. \n"
        + "\n" + message + "\n" +  "\n" +
        "Press Enter to try again.";
        scoreDisplay.x=GEngine.virtualWidth/2-scoreDisplay.width()*0.5;
        scoreDisplay.y=GEngine.virtualHeight/2;
        scoreDisplay.color=Color.Red;
        stage.addChild(scoreDisplay);
    }
    var time:Float=0;
    var targetPosition:FastVector2;
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Return)){
            changeState(new Intro()); 
        }

    }
}