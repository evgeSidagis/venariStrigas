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
import com.collision.platformer.CollisionGroup;


/**
 * ...
 * @author 
 */
class Enemy extends Entity
{
	static private inline var SPEED:Float = 250;
    public var health : Int; 
	
	public function new() 
	{
		super();
	}
	override function update(dt:Float ):Void
	{
		super.update(dt);
	}
	
	override function render() {
		super.render();
	}
    
    public function damage(dmg: Int) {
        health -= dmg;
        if (health <= 0){
            die();
        }
    }
}