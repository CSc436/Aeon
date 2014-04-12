package org.interguild.game.collision {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.interguild.Aeon;
	import org.interguild.game.Player;
	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.GameObject;
	import org.interguild.game.tiles.Tile;

	public class CollisionGrid extends Sprite {

		private var level:Level;
		private var grid:Array;

		private var allObjects:Vector.<GameObject>;
		public var activeObjects:Vector.<GameObject>;

		private var removalObjects:Array;
		private var deactivateObjects:Array;

		public function CollisionGrid(width:int, height:int, level:Level) {
			this.level = level;
			removalObjects = new Array();
			deactivateObjects = new Array();

			//init lists
			allObjects = new Vector.<GameObject>();
			activeObjects = new Vector.<GameObject>();

			//init 2D array
			grid = new Array(height);
			for (var i:uint = 0; i < height; i++) {
				grid[i] = new Array(width);
				for (var j:uint = 0; j < width; j++) {
					var g:GridTile = new GridTile(i, j, this);
					grid[i][j] = g;

					CONFIG::DEBUG {
						g.x = j * 32;
						g.y = i * 32;
						addChild(grid[i][j]);
					}
				}
			}
		}

		private function inBounds(row:int, col:int):Boolean {
			return (row >= 0 && row < grid.length && col >= 0 && col < grid[0].length);
		}

		public function addObject(tile:CollidableObject):void {
			allObjects.push(tile);
			if (tile.isActive)
				activeObjects.push(tile);
			updateObject(tile, !tile.isActive);
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
			var row:int, col:int;
			var gridTile:GridTile;

			var top:int = box.top / Aeon.TILE_HEIGHT;
			var left:int = box.left / Aeon.TILE_WIDTH;
			var bottom:int = (box.bottom - 1) / Aeon.TILE_HEIGHT;
			var right:int = (box.right - 1) / Aeon.TILE_WIDTH;
			if(o is Player){
				top--;
				left--;
				bottom++;
				right++;
			}

			//remove old grids
			o.clearGrids();

			//add new grids
			for (row = top; row <= bottom; row++) {
				if (top >= 0 && top < grid.length) {
					for (col = left; col <= right; col++) {
						if (col >= 0 && col < grid[0].length) {
							gridTile = grid[row][col];
							gridTile.addObject(o);
							o.addGridTile(gridTile);
							if (blockNeighbors) {
								updateBlockedNeighbors(row, col, o);
							}
						}
					}
				}
			}
		}

		private function getDistance(obj1:CollidableObject, obj2:CollidableObject):Number {
			var center1:Point = new Point(obj1.hitbox.x + obj1.hitbox.width / 2, obj1.hitbox.y + obj1.hitbox.height / 2);
			var center2:Point = new Point(obj2.hitbox.x + obj2.hitbox.width / 2, obj2.hitbox.y + obj2.hitbox.height / 2);
			var distx:Number = center2.x - center1.x;
			var disty:Number = center2.y - center2.y;

			return Math.sqrt(distx * distx + disty * disty);
		}

		private function getSlope(p1:Point, p2:Point):Number {
			return (p2.y - p1.y) / (p2.x - p1.x);
		}

		/**
		 * Handle collisions!
		 */
		public function detectAndHandleCollisions(target:CollidableObject):Array {
			//maintain a list of nearby objects, ordered by proximity
			var objectsToTest:Array = new Array();

			var gTiles:Vector.<GridTile> = target.myCollisionGridTiles;
			var len:uint = gTiles.length;
			//iterate through all of the Collision GridTiles that the target is in
			for (var i:uint = 0; i < len; i++) {
				var tile:GridTile = gTiles[i];
				var gObjs:Vector.<CollidableObject> = tile.myCollisionObjects;
				var olen:uint = gObjs.length;
				//interate through all of the objects in each GridTile
				for (var j:uint = 0; j < olen; j++) {
					var obj:CollidableObject = gObjs[j];
					if (target != obj) {
						var distance:Number = getDistance(obj, target);
						var toInsert:Array = new Array(distance, obj);

						//add to list, ordered by proximity to target
						var alen:uint = objectsToTest.length;
						var tmp:Array = null;
						for (var k:uint = 0; k < alen; k++) {
							//shifting elements down the array
							if (tmp != null) {
								var tmp2:Array = objectsToTest[k];
								objectsToTest[k] = tmp;
								tmp = tmp2;
									// if to be inserted at this location
							} else if (distance < objectsToTest[k][0]) {
								tmp = objectsToTest[k];
								objectsToTest[k] = toInsert;
							}
						}
//						//finish shifting elements
						if (tmp != null) {
							objectsToTest[objectsToTest.length] = tmp;
								//or insert element to end
						} else {
							objectsToTest[objectsToTest.length] = toInsert;
						}
					}
				}
			}

			//now we can test collisions between obj and target
			//iterate
			var mlen:uint = objectsToTest.length;
			for (var m:uint = 0; m < mlen; m++) {
				var other:CollidableObject = objectsToTest[m][1];

				if (!target.hasCollidedWith(other) && target.hitboxWrapper.intersects(other.hitboxWrapper)) {
					//if they are colliding:
					handleCollision(target, other);
				}
			}

			return removalObjects;
		}

		private function determineDirection(activeObject:CollidableObject, otherObject:CollidableObject, activeBoxPrev:Rectangle, otherBoxPrev:Rectangle, activeBoxCurr:Rectangle, otherBoxCurr:Rectangle):uint {
			if (activeBoxCurr.intersects(otherBoxPrev)) {
				/*
				 * SIMPLE ONE-DIRECITON CASES
				 */
				if (!otherObject.isBlocked(Direction.UP) && activeBoxPrev.bottom <= otherBoxPrev.top && activeBoxCurr.bottom >= otherBoxCurr.top) {
					/*
					* --------------
					* |activeObject|
					* --------------
					* |otherObject |
					* --------------
					*/
					return Direction.DOWN;
				} else if (!otherObject.isBlocked(Direction.DOWN) && activeBoxPrev.top >= otherBoxPrev.bottom && activeBoxCurr.top <= otherBoxCurr.bottom) {
					/*
					* --------------
					* |otherObject |
					* --------------
					* |activeObject|
					* --------------
					*/
					return Direction.UP;
				} else if (!otherObject.isBlocked(Direction.LEFT) && activeBoxPrev.right <= otherBoxPrev.left && activeBoxCurr.right >= otherBoxCurr.left) {
					/*
					* |------------||-----------|
					* |activeObject||otherObject|
					* |------------||-----------|
					*/
					return Direction.RIGHT;
				} else if (!otherObject.isBlocked(Direction.RIGHT) && activeBoxPrev.left >= otherBoxPrev.right && activeBoxCurr.left <= otherBoxCurr.right) {
					/*
					* |-----------||------------|
					* |otherObject||activeObject|
					* |-----------||------------|
					*/
					return Direction.LEFT;
				}
			} else {
				/*
				 * COMPLICATED CORNER CASES
				 */
				var slopeSelf:Number;
				var slopeOther:Number
				var activePoint1:Point;
				var activePoint2:Point;
				var otherPoint1:Point;
				var otherPoint2:Point;
				//going down-right	//compare top-right point to bottom-left point
				if (activeObject.speedX > 0 && activeObject.speedY > 0) {
					activePoint1 = new Point(activeBoxPrev.right, activeBoxPrev.top);
					activePoint2 = new Point(activeBoxCurr.right, activeBoxCurr.top);
					otherPoint1 = new Point(otherBoxPrev.right, otherBoxPrev.top);
					otherPoint2 = new Point(otherBoxCurr.right, otherBoxCurr.top);
					slopeSelf = getSlope(activePoint2, activePoint1);
					slopeOther = getSlope(otherPoint2, otherPoint1);
					if (slopeSelf > slopeOther) {
						return Direction.RIGHT;
					}
				}
			}
			return Direction.NONE;
		}

		public function handleCollision(activeObject:CollidableObject, otherObject:CollidableObject):void {
			activeObject.setCollidedWith(otherObject);
			otherObject.setCollidedWith(activeObject);
			var p:Player = null;
			var activeBoxPrev:Rectangle = activeObject.hitboxPrev;
			var otherBoxPrev:Rectangle = otherObject.hitboxPrev;
			var activeBoxCurr:Rectangle = activeObject.hitbox;
			var otherBoxCurr:Rectangle = otherObject.hitbox;

			//NOTE: just because this method was called, it doesn't mean that there was a collision

			// get dirction of collision
			var direction:uint = determineDirection(activeObject, otherObject, activeBoxPrev, otherBoxPrev, activeBoxCurr, otherBoxCurr);

			if (activeObject is Player) {
				p = Player(activeObject);
			}
			if (!(otherObject is Tile) || !(activeObject is Tile)) {
				//will never ever happen
				throw new Error("Please handle non-Tile collisions in special cases before this line.");
			}

			var activeTile:Tile = Tile(activeObject);
			var otherTile:Tile = Tile(otherObject);

			/*
			 * PLAYER HITS CRATE
			 */
			if (p && otherTile.getDestructibility() == 2) {
				// knockback stuff:
				if (otherTile.doesKnockback() > 0) {
					if (direction == Direction.DOWN) {
						p.speedY = Player.KNOCKBACK_JUMP_SPEED;
					} else if (direction == Direction.UP) {
						activeObject.speedY = 0;
					} else if (direction == Direction.RIGHT) {
						activeObject.speedX = -Player.KNOCKBACK_HORIZONTAL;
					} else if (direction == Direction.LEFT) {
						activeObject.speedX = Player.KNOCKBACK_HORIZONTAL;
					}
				}
				removalObjects.push(otherObject);

				/*
				 * SOLID COLLISIONS
				 */
			} else if (activeTile.isSolid() && otherTile.isSolid()) {
				if (direction == Direction.DOWN) {
					activeObject.newY = otherBoxPrev.top - activeBoxCurr.height;
					activeObject.speedY = 0;
					if (p) {
						p.isStanding = true;
					} else if (otherObject is Player) { //player got crushed by falling solid object
						Player(otherObject).die();
						return;
					} else {
						deactivateObjects.push(activeObject);
					}
				} else if (direction == Direction.UP) {
					if (otherTile.isActive) {
						if (p) { //player got crushed by falling solid object
							p.die();
							return;
						}
						otherObject.newY = activeBoxCurr.bottom;
						otherObject.speedY = 0;
					} else {
						activeObject.newY = otherBoxCurr.bottom;
						activeObject.speedY = 0;
					}
				} else if (direction == Direction.RIGHT) {
					activeObject.newX = otherBoxCurr.left - activeBoxCurr.width;
					activeObject.speedX = 0;
				} else if (direction == Direction.LEFT) {
					activeObject.newX = otherBoxCurr.right;
					activeObject.speedX = 0;
				}
			}
		}

		public function destroyObject(obj:CollidableObject):void {
			//remove from activeObjects list
			if (!obj.isActive) {
				var tile:GridTile = obj.myCollisionGridTiles[0];
				if (inBounds(tile.gridRow - 1, tile.gridCol)) {
					tile = grid[tile.gridRow - 1][tile.gridCol];
					tile.activate();
				}
			}
			obj.clearGrids();

//			var tile:GridTile = toDestroy.myCollisionGridTiles[0];
//			unblockNeighbors(tile.gridRow, tile.gridCol);
//			if (inBounds(tile.gridRow - 1, tile.gridCol) && grid[tile.gridRow - 1][tile.gridCol].myCollisionObjects.length > 0) {
//				for (var i:int = 0; i < grid[tile.gridRow - 1][tile.gridCol].myCollisionObjects.length; i++) {
//					if (!(grid[tile.gridRow - 1][tile.gridCol].myCollisionObjects[i] is Player)) {
//						var obj:CollidableObject = grid[tile.gridRow - 1][tile.gridCol].myCollisionObjects[0];
//						level.activateObject(obj);
//						obj.setUnblocked(Direction.UP);
//					}
//				}
//			}
		}

		public function get deactivationList():Array {
			return deactivateObjects;
		}

		public function get removalList():Array {
			return removalObjects;
		}

		public function resetDeactivationList():void {
			deactivateObjects = new Array();
		}

		public function resetRemovalList():void {
			removalObjects = new Array();
		}

		public function getGrid():Array {
			return grid;
		}

		/**
		 * Leave the third parameter null to unblock, rather than block
		 */
		public function updateBlockedNeighbors(row:int, col:int, o:CollidableObject = null):void {
			var gridTile:GridTile;

			//top
			var bx:int = col;
			var by:int = row - 1;
			if (inBounds(by, bx)) {
				gridTile = grid[by][bx];
				if (o) {
					gridTile.block(Direction.DOWN);
					if (gridTile.isBlocking()) {
						o.setBlocked(Direction.UP);
					}
				} else {
					gridTile.unblock(Direction.DOWN);
				}
			}

			//down
			by = row + 1;
			if (inBounds(by, bx)) {
				gridTile = grid[by][bx];
				if (o) {
					gridTile.block(Direction.UP);
					if (gridTile.isBlocking()) {
						o.setBlocked(Direction.DOWN);
					}
				} else {
					gridTile.unblock(Direction.UP);
				}
			}

			//right
			bx = col + 1;
			by = row;
			if (inBounds(by, bx)) {
				gridTile = grid[by][bx];
				if (o) {
					gridTile.block(Direction.LEFT);
					if (gridTile.isBlocking()) {
						o.setBlocked(Direction.RIGHT);
					}
				} else {
					gridTile.unblock(Direction.LEFT);
				}
			}

			//left
			bx = col - 1;
			if (inBounds(by, bx)) {
				gridTile = grid[by][bx];
				if (o) {
					gridTile.block(Direction.RIGHT);
					if (gridTile.isBlocking()) {
						o.setBlocked(Direction.LEFT);
					}
				} else {
					gridTile.unblock(Direction.RIGHT);
				}
			}
		}
	}
}
