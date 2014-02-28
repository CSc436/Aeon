package org.interguild.game.collision {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import flexunit.utils.ArrayList;
	
	import org.interguild.Aeon;
	import org.interguild.game.Player;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.Tile;

	public class CollisionGrid /*DEBUG*/extends Sprite /*END DEBUG*/ {

		private var grid:Array;
		private var removalObjects:ArrayList;

		public function CollisionGrid(width:int, height:int) {
			//init 2D array
			removalObjects = new ArrayList;
			grid = new Array(height);
			for (var i:uint = 0; i < height; i++) {
				grid[i] = new Array(width);
				for (var j:uint = 0; j < width; j++) {
					var g:GridTile = new GridTile(i, j);
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
		 *
		 * If blockNeighbors is set to true, will notify
		 * the four adjacent tiles that they are now blocked
		 * on that side, so they shouldn't bother testing
		 * for collisions there. BlockNeighbors assumes that
		 * you only take up one grid tile.
		 */
		public function updateObject(o:CollidableObject, blockNeighbors:Boolean):void {
			var inGrids:Array = new Array();
			var box:Rectangle = o.hitbox;
			var gx:int;
			var gy:int;
			var gy0:int;
			var gridTile:GridTile;

			//top left
			gx = box.left / Aeon.TILE_WIDTH;
			gy = gy0 = box.top / Aeon.TILE_HEIGHT;
			gridTile = grid[gy][gx];
			if (inBounds(gy, gx)) {
				inGrids.push(gridTile);

				//naively handle blockNeighbors for only one gridTile case
				if (blockNeighbors) {
					//top
					var bx:int = gx;
					var by:int = gy - 1;
					if (inBounds(bx, by)) {
						gridTile = grid[by][bx]
						gridTile.block(Direction.DOWN);
						if (gridTile.isBlocking()) {
							o.setBlocked(Direction.UP);
						}
					}

					//down
					by = gy + 1;
					if (inBounds(bx, by)) {
						gridTile = grid[by][bx]
						gridTile.block(Direction.UP);
						if (gridTile.isBlocking()) {
							o.setBlocked(Direction.DOWN);
						}
					}

					//right
					bx = gx + 1;
					by = gy;
					if (inBounds(bx, by)) {
						gridTile = grid[by][bx]
						gridTile.block(Direction.LEFT);
						if (gridTile.isBlocking()) {
							o.setBlocked(Direction.RIGHT);
						}
					}

					//left
					bx = gx - 1;
					if (inBounds(bx, by)) {
						gridTile = grid[by][bx]
						gridTile.block(Direction.RIGHT);
						if (gridTile.isBlocking()) {
							o.setBlocked(Direction.LEFT);
						}
					}
				}
			}

			//top right
			gx = (box.right - 1) / Aeon.TILE_WIDTH;
			gridTile = grid[gy][gx];
			if (inBounds(gy, gx) && inGrids.indexOf(gridTile) == -1)
				inGrids.push(gridTile);

			//bottom right
			gy = (box.bottom - 1) / Aeon.TILE_HEIGHT;
			gridTile = grid[gy][gx];
			if (inBounds(gy, gx) && inGrids.indexOf(gridTile) == -1)
				inGrids.push(gridTile);

			//bottom left
			gx = box.left / Aeon.TILE_WIDTH;
			gridTile = grid[gy][gx];
			if (inBounds(gy, gx) && inGrids.indexOf(gridTile) == -1)
				inGrids.push(gridTile);

			//middle cases if player
			if (gy - gy0 > 1) {
				gy -= 1;

				//middle left
				gridTile = grid[gy][gx];
				if (inBounds(gy, gx) && inGrids.indexOf(gridTile) == -1)
					inGrids.push(gridTile);

				//middle right
				gx = (box.right - 1) / Aeon.TILE_WIDTH;
				gridTile = grid[gy][gx];
				if (inBounds(gy, gx) && inGrids.indexOf(gridTile) == -1)
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

		private function inBounds(row:int, col:int):Boolean {
			return (row >= 0 && row < grid.length && col >= 0 && col < grid[0].length);
		}

		/**
		 * Handle collisions!
		 */
		public function detectAndHandleCollisions(target:CollidableObject):ArrayList {

			//iterate through all of the Collision GridTiles that the target is in
			var gTiles:Vector.<GridTile> = target.myCollisionGridTiles;
			var len:uint = gTiles.length;
			for (var i:uint = 0; i < len; i++) {
				//interate through all of the objects in each GridTile
				var tile:GridTile = gTiles[i];
				var gObjs:Vector.<CollidableObject> = tile.myCollisionObjects;
				var olen:uint = gObjs.length;
				for (var j:uint = 0; j < olen; j++) {
					//now we can test collisions between obj and target
					var obj:CollidableObject = gObjs[j];

					if (target != obj && !target.hasCollidedWith(obj) && target.hitbox.intersects(obj.hitbox)) {
						//if they are colliding:
						handleCollision(target, obj);
					}
				}
			}
			return removalObjects;
		}

		public function handleCollision(activeObject:CollidableObject, otherObject:CollidableObject):void {
			activeObject.setCollidedWith(otherObject);
			otherObject.setCollidedWith(activeObject);

			if (activeObject is Player) {
				var p:Player = Player(activeObject);
				if (otherObject is Tile) {
					var t:Tile = Tile(otherObject);
					//player on tile collisions

					//solid collisions!!
					if (t.isSolid()) {
						var activeBoxPrev:Rectangle = activeObject.hitboxPrev;
						var otherBoxPrev:Rectangle = otherObject.hitboxPrev;
						var activeBoxCurr:Rectangle = activeObject.hitbox;
						var otherBoxCurr:Rectangle = otherObject.hitbox;


						if (!otherObject.isBlocked(Direction.UP) && activeBoxPrev.bottom <= otherBoxPrev.top && activeBoxCurr.bottom >= otherBoxCurr.top) {
							/*
							 * --------------
							 * |activeObject|
							 * --------------
							 * |otherObject |
							 * --------------
							 */
							activeObject.newY = otherBoxCurr.top - activeBoxCurr.height;
							activeObject.speedY = 0;
							//set player standing
							p.isStanding = true;
						} else if (!otherObject.isBlocked(Direction.DOWN) && activeBoxPrev.top >= otherBoxPrev.bottom && activeBoxCurr.top <= otherBoxCurr.bottom) {
							/*
							 * --------------
							 * |otherObject |
							 * --------------
							 * |activeObject|
							 * --------------
							 */
							activeObject.newY = otherBoxCurr.bottom;
							activeObject.speedY = 0;
						} else if (!otherObject.isBlocked(Direction.LEFT) && activeBoxPrev.right <= otherBoxPrev.left && activeBoxCurr.right >= otherBoxCurr.left) {
							/*
							* |------------||-----------|
							* |activeObject||otherObject|
							* |------------||-----------|
							*/
							activeObject.newX = otherBoxCurr.left - activeBoxCurr.width;
							activeObject.speedX = 0;
						} else if (!otherObject.isBlocked(Direction.RIGHT) && activeBoxPrev.left >= otherBoxPrev.right && activeBoxCurr.left <= otherBoxCurr.right) {
							/*
							* |-----------||------------|
							* |otherObject||activeObject|
							* |-----------||------------|
							*/
							activeObject.newX = otherBoxCurr.right;
							activeObject.speedX = 0;
						}

						//destructible
						if (t.getDestructibility() == 2) {
							//doesn't knockback ie wood crate
							if (t.doesKnockback() > 0) {

								removalObjects.addItem(otherObject);
							}
						}
					}
				} else {
					//other Object is nothing (yet)
					//will never ever happen
					trace("CollisionGrid says: How did this happen!?");
				}
			} else {

			}
		}

		public function resetRemovalList():void {
			removalObjects = new ArrayList;
		}

		public function unblockNeighbors(g:GridTile):void {
			var gridTile:GridTile;
			
			//top
			var bx:int = g.gridCol;
			var by:int = g.gridRow - 1;
			if (inBounds(bx, by)) {
				gridTile = grid[by][bx]
				gridTile.unblock(Direction.DOWN);
			}
			
			//down
			by = g.gridRow + 1;
			if (inBounds(bx, by)) {
				gridTile = grid[by][bx]
				gridTile.unblock(Direction.UP);
			}
			
			//right
			bx = g.gridCol + 1;
			by = g.gridRow;
			if (inBounds(bx, by)) {
				gridTile = grid[by][bx]
				gridTile.unblock(Direction.LEFT);
			}
			
			//left
			bx = g.gridCol - 1;
			if (inBounds(bx, by)) {
				gridTile = grid[by][bx]
				gridTile.unblock(Direction.RIGHT);
			}
		}
	}
}
