package org.interguild.loader {

	import org.interguild.Aeon;
	import org.interguild.game.Player;
	import org.interguild.game.collision.Direction;
	import org.interguild.game.Level;
	import org.interguild.game.tiles.ArrowCrate;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.DynamiteCrate;
	import org.interguild.game.tiles.FinishLine;
	import org.interguild.game.tiles.SteelCrate;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;

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

		protected override function setLevelInfo():void {
			//create the level
			level = new Level(this.levelWidth, this.levelHeight, backgroundType);
			level.title = this.title;
			level.terrainType = this.terrainType;
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
					tile = new ArrowCrate(px, py, Direction.RIGHT);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_DOWN:
					tile = new ArrowCrate(px, py, Direction.DOWN);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_LEFT:
					tile = new ArrowCrate(px, py, Direction.LEFT);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_UP:
					tile = new ArrowCrate(px, py, Direction.UP);
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
					level.setFinish(FinishLine(tile));
					break;
				default:
					//trace("LevelLoader: Unknown level code character: '" + curChar + "'");
					break;
			}
		}

		protected override function finishLoading():void {
			level.finishLoading();
		}
	}
}
