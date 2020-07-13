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

class Ending extends State {
    var intro:Sprite;
    override function load(resources:Resources) {
        resources.add(new ImageLoader("Ending"));
        resources.add(new SoundLoader("KyubeyTheme", false));
    }
    public function new() {
        super();
    }
    override function init() {
        intro=new Sprite("Ending");
        SoundManager.playMusic("KyubeyTheme", true);
        SoundManager.musicVolume(1);
        stage.addChild(intro);
    }
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Space)||Input.i.isMousePressed()||Input.i.isKeyCodePressed(KeyCode.Return)){
            changeState(new Intro()); 	
        }
    }
}