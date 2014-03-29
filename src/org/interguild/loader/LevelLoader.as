package org.interguild.loader {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.SteelCrate;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;
	import org.interguild.game.level.Level;

	/**
	 * Takes in a level encoding and constructs a level.
	 * 
	 * HOW TO USE
	 * 
	 * 1. Create new LevelLoader
	 * 2. Set up all of the Listeners (callbacks) that you want.
	 *    (see Listener functions below)
	 */
	public class LevelLoader extends Loader {

		private var level:Level;
		
		protected override function setLevelInfo(title:String, lvlWidth:uint, lvlHeight:uint):void{
			//create the level
			level = new Level(lvlWidth, lvlHeight);
			level.title = title;
			initializedCallback(level);
		}

		protected override function initObject(curChar:String, px:int, py:int):void {
			//if off the map, do nothing
			if (px >= level.widthInPixels || py >= level.heightInPixels)
				return;

			var tile:CollidableObject;
			switch (curChar) {
				case "#": //Player
					level.setPlayer(px, py);
					break;
				case "x": //Terrain
					tile = new Terrain(px, py);
					level.createCollidableObject(tile, false);
					break;
				case "w": //WoodCrate
					tile = new WoodCrate(px, py);
					level.createCollidableObject(tile, false);
					break;
				case "s": //SteelCrate
					tile = new SteelCrate(px, py);
					level.createCollidableObject(tile, false);
				default:
					trace("Unknown level code character: '" + curChar + "'");
					break;
			}
		}
	}
}
