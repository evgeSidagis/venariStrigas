package states;

import com.gEngine.GEngine;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Sprite;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.loading.basicResources.ImageLoader;
import com.loading.basicResources.SoundLoader;
import com.soundLib.SoundManager;
import com.loading.Resources;
import com.framework.utils.State;

class Intro extends State {
    var intro:Sprite;
    override function load(resources:Resources) {
        resources.add(new ImageLoader("Intro"));
        resources.add(new SoundLoader("Inevitabilis"));
    }
    public function new() {
        super();
    }
    override function init() {
        intro=new Sprite("Intro");
        SoundManager.playMusic("Inevitabilis",false);
        stage.addChild(intro);
    }
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Space)||Input.i.isMousePressed()){
            changeState(new GameState("FirstAreaD")); 	
        }
    }
}