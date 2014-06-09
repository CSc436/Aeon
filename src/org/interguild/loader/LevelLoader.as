package org.interguild.loader {

	import org.interguild.Aeon;
	import org.interguild.game.Level;
	import org.interguild.game.tiles.Player;
	import org.interguild.game.collision.Direction;
	import org.interguild.game.tiles.Arrow;
	import org.interguild.game.tiles.ArrowCrate;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.DynamiteSteelCrate;
	import org.interguild.game.tiles.DynamiteStick;
	import org.interguild.game.tiles.DynamiteWoodCrate;
	import org.interguild.game.tiles.Explosion;
	import org.interguild.game.tiles.FinishLine;
	import org.interguild.game.tiles.Platform;
	import org.interguild.game.tiles.SecretArea;
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

		private static const FAKE_X:int = -500;
		private static const FAKE_Y:int = -500;

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
			var arrow:Arrow;
			var explosion:Explosion;
			var stick:DynamiteStick;
			switch (curChar) {
				case Player.LEVEL_CODE_CHAR:
					level.setPlayer(px, py);
					break;
				case Terrain.LEVEL_CODE_CHAR:
					tile = new Terrain(px, py);
					level.createCollidableObject(tile);
					break;
				case SecretArea.LEVEL_CODE_CHAR:
					tile = new SecretArea(px, py);
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
				case ArrowCrate.LEVEL_CODE_CHAR_WOOD_RIGHT:
				case ArrowCrate.LEVEL_CODE_CHAR_STEEL_RIGHT:
					arrow = new Arrow(FAKE_X, FAKE_Y, Direction.RIGHT);
					level.createCollidableObject(arrow, true);
					tile = new ArrowCrate(px, py, Direction.RIGHT, arrow, curChar == ArrowCrate.LEVEL_CODE_CHAR_STEEL_RIGHT);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_WOOD_DOWN:
				case ArrowCrate.LEVEL_CODE_CHAR_STEEL_DOWN:
					arrow = new Arrow(FAKE_X, FAKE_Y, Direction.DOWN);
					level.createCollidableObject(arrow, true);
					tile = new ArrowCrate(px, py, Direction.DOWN, arrow, curChar == ArrowCrate.LEVEL_CODE_CHAR_STEEL_DOWN);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_WOOD_LEFT:
				case ArrowCrate.LEVEL_CODE_CHAR_STEEL_LEFT:
					arrow = new Arrow(FAKE_X, FAKE_Y, Direction.LEFT);
					level.createCollidableObject(arrow, true);
					tile = new ArrowCrate(px, py, Direction.LEFT, arrow, curChar == ArrowCrate.LEVEL_CODE_CHAR_STEEL_LEFT);
					level.createCollidableObject(tile);
					break;
				case ArrowCrate.LEVEL_CODE_CHAR_WOOD_UP:
				case ArrowCrate.LEVEL_CODE_CHAR_STEEL_UP:
					arrow = new Arrow(FAKE_X, FAKE_Y, Direction.UP);
					level.createCollidableObject(arrow, true);
					tile = new ArrowCrate(px, py, Direction.UP, arrow, curChar == ArrowCrate.LEVEL_CODE_CHAR_STEEL_UP);
					level.createCollidableObject(tile);
					break;
				case Collectable.LEVEL_CODE_CHAR:
					tile = new Collectable(px, py);
					level.createCollidableObject(tile);
					break;
				case Platform.LEVEL_CODE_CHAR:
					tile = new Platform(px, py);
					level.createCollidableObject(tile);
					break;
				case DynamiteWoodCrate.LEVEL_CODE_CHAR:
					explosion = new Explosion(FAKE_X, FAKE_Y);
					level.createCollidableObject(explosion, true);
					stick = new DynamiteStick(FAKE_X, FAKE_Y, explosion);
					level.createCollidableObject(stick, true);
					tile = new DynamiteWoodCrate(px, py, stick, explosion);
					level.createCollidableObject(tile);
					break;
				case DynamiteSteelCrate.LEVEL_CODE_CHAR:
					explosion = new Explosion(FAKE_X, FAKE_Y);
					level.createCollidableObject(explosion, true);
					tile = new DynamiteSteelCrate(px, py, explosion);
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
