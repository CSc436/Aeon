package org.interguild.game.collision {
	import flash.display.Sprite;
	
	import org.interguild.Aeon;
	import org.interguild.game.tiles.CollidableObject;

	public class CollisionGrid /*DEBUG*/extends Sprite /*END DEBUG*/ {

		private var grid:Array;

		public function CollisionGrid(width:int, height:int) {
			//init 2D array
			grid = new Array(height);
			for (var i:uint = 0; i < height; i++) {
				grid[i] = new Array(width);
				for (var j:uint = 0; j < width; j++) {
					var g:GridTile = new GridTile();
					grid[i][j] = g;
					/*DEBUG*/
					g.x = j * 32;
					g.y = i * 32;
					addChild(grid[i][j]);
					/*END DEBUG*/
				}
			}
		}

		/**
		 * To be called during initialization. Adds the
		 * object to its correct GridTile.
		 */
		public function addObject(o:CollidableObject):void {
			var gx:int = o.x / Aeon.TILE_WIDTH;
			var gy:int = o.y / Aeon.TILE_HEIGHT;
			GridTile(grid[gy][gx]).addObject(o);
			o.addGridTile(grid[gy][gx]);
		}

		public function detectAndHandle():void {

		}

		public function updatePlayer():void {

		}
	}
}
