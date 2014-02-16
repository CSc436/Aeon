package org.interguild.game.collision {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
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
		public function updateObject(o:CollidableObject):void {
			var inGrids:Array = new Array();
			var box:Rectangle = o.hitbox;
			var gx:int;
			var gy:int;
			var gy0:int;
			var gridTile:GridTile;

			//top left
			gx = box.left / Aeon.TILE_WIDTH;
			gy0 = gy = box.top / Aeon.TILE_HEIGHT;
			gridTile = grid[gy][gx];
			inGrids.push(gridTile);

			//top right
			gx = (box.right - 1) / Aeon.TILE_WIDTH;
			gridTile = grid[gy][gx];
			if (inGrids.indexOf(gridTile) == -1)
				inGrids.push(gridTile);
			
			//bottom right
			gy = (box.bottom - 1) / Aeon.TILE_HEIGHT;
			gridTile = grid[gy][gx];
			if (inGrids.indexOf(gridTile) == -1)
				inGrids.push(gridTile);

			//bottom left
			gx = box.left / Aeon.TILE_WIDTH;
			gridTile = grid[gy][gx];
			if (inGrids.indexOf(gridTile) == -1)
				inGrids.push(gridTile);
			
			//middle cases
			if(gy - gy0 > 1){
				gy -= 1;
				
				//middle left
				gridTile = grid[gy][gx];
				if (inGrids.indexOf(gridTile) == -1)
					inGrids.push(gridTile);
				
				//middle right
				gx = (box.right - 1) / Aeon.TILE_WIDTH;
				gridTile = grid[gy][gx];
				if (inGrids.indexOf(gridTile) == -1)
					inGrids.push(gridTile);
			}

			//remove old grids
			o.clearGrids();
			
			//add current grids
			for (var i:uint = 0; i < inGrids.length; i++) {
				var g:GridTile = inGrids[i];
				g.addObject(o);
				o.addGridTile(g);
			}
		}

		public function detectAndHandle():void {

		}

		public function updatePlayer():void {

		}
	}
}
