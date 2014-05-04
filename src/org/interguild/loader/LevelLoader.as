package org.interguild.loader {

	import org.interguild.Aeon;
	import org.interguild.game.Player;
	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.ArrowCrate;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.FinishLine;
	import org.interguild.game.tiles.SteelCrate;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;
	import org.interguild.game.tiles.DynamiteCrate;

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
			px *= Aeon.TILE_WIDTH;
			py *= Aeon.TILE_HEIGHT;

			var tile:CollidableObject;
			switch (curChar) {
				case Player.LEVEL_CODE_CHAR:
					level.setPlayer(px, py);
					break;
				case Terrain.LEVEL_CODE_CHAR:
					tile = new Terrain(px, py);
					level.createCollidableObject(tile);
					break;
				case WoodCrate.LEVEL_CODE_CHAR:
					tile = new WoodCrate(px, py);
					level.createCollidableObject(tile);
					break;
				case SteelCrate.LEVEL_CODE_CHAR:
					tile = new SteelCrate(px, py);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_RIGHT:
					tile = new ArrowCrate(px, py, 1);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_DOWN:
					tile = new ArrowCrate(px, py, 2);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_LEFT:
					tile = new ArrowCrate(px, py, 3);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_UP:
					tile = new ArrowCrate(px, py, 4);
					level.createCollidableObject(tile);
					break;
				case Collectable.LEVEL_CODE_CHAR:
					tile = new Collectable(px, py);
					level.createCollidableObject(tile);
					break;
				case DynamiteCrate.LEVEL_CODE_CHAR:
					tile = new DynamiteCrate(px, py);
					level.createCollidableObject(tile);
					break;
				case FinishLine.LEVEL_CODE_CHAR:
					tile = new FinishLine(px, py);
					level.createCollidableObject(tile);
					break;
				default:
					//trace("LevelLoader: Unknown level code character: '" + curChar + "'");
					break;
			}
		}
		
		protected override function finishLoading():void{
			level.finishLoading();
		}
	}
}
