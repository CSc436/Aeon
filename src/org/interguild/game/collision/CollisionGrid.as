package org.interguild.game.collision {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;

	import org.interguild.Aeon;
	import org.interguild.INTERGUILD;
	import org.interguild.game.Player;
	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.Explosion;
	import org.interguild.game.tiles.FinishLine;
	import org.interguild.game.tiles.GameObject;

	public class CollisionGrid extends Sprite {

		private var level:Level;
		private var grid:Array;

		private var allObjects:Vector.<GameObject>;
		public var activeObjects:Vector.<GameObject>;

		private var removalObjects:Array;
		private var deactivateObjects:Array;

		private var jump:Sound;
		private var coin:Sound;

		public function CollisionGrid(width:int, height:int, level:Level) {
			this.level = level;
			removalObjects = new Array();
			deactivateObjects = new Array();

			//init lists
			allObjects = new Vector.<GameObject>();
			activeObjects = new Vector.<GameObject>();

			jump = new Sound();
			CONFIG::ONLINE {
				jump.load(new URLRequest(INTERGUILD.ORG + "/aeon_demo/jump.mp3")); //remote
			}
			CONFIG::OFFLINE {
				jump.load(new URLRequest("../assets/jump.mp3")); //local
			}

			coin = new Sound();
			CONFIG::ONLINE {
				coin.load(new URLRequest(INTERGUILD.ORG + "/aeon_demo/coin.mp3")); //remote
			}
			CONFIG::OFFLINE {
				coin.load(new URLRequest("../assets/coin.mp3")); //local
			}

			//init 2D arra]y
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
			if (o is Player) {
				top--;
				left--;
				bottom++;
				right++;
			}

			//remove old grids
			o.clearGrids();

			//add new grids
			for (row = top; row <= bottom; row++) {
				if (row >= 0 && row < grid.length) {
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
			var center1:Point = new Point(obj1.hitboxPrev.x + obj1.hitboxPrev.width / 2, obj1.hitboxPrev.y + obj1.hitboxPrev.height / 2);
			var center2:Point = new Point(obj2.hitboxPrev.x + obj2.hitboxPrev.width / 2, obj2.hitboxPrev.y + obj2.hitboxPrev.height / 2);
			var distx:Number = center2.x - center1.x;
			var disty:Number = center2.y - center1.y;

			return Math.sqrt((distx * distx) + (disty * disty));
		}



		/**
		 * Handle collisions!
		 */
		public function detectAndHandleCollisions(target:CollidableObject):void {
			if (target is Explosion) {
				var e:Explosion = Explosion(target);
				if (e.timeCounter >= 15)
					toRemove(target);
			}

			var objectsToTest:ObjectsToTestList = getNearbyObjects(target);
			objectsToTest.prepareToIterate();
			while (objectsToTest.hasNext()) {
				var current:ObjectsToTestEntry = objectsToTest.next();

				var other:CollidableObject = current.object;
				var active:CollidableObject = target;

				// HACKY STUFF BELOW //
				if ((target is Player && Player(target).isDead) || (other is Player && Player(other).isDead))
					continue;
				// HACKY STUFF ABOVE //

				if (!active.hasCollidedWith(other) && active.hitboxWrapper.intersects(other.hitboxWrapper)) {
					handleCollision(active, other);
				}
			}
		}

		/**
		 * Returns a list of nearby objects, ordered by proximity and other things.
		 */
		private function getNearbyObjects(target:CollidableObject):ObjectsToTestList {
			var list:ObjectsToTestList = new ObjectsToTestList();

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
						//if potential corner collision
						if (!target.hitbox.intersects(obj.hitbox)) {
							distance = 0;
						}
						list.insertInOrder(new ObjectsToTestEntry(distance, obj));
					}
				}
			}
			return list;
		}

		public function handleCollision(activeObject:CollidableObject, otherObject:CollidableObject):void {
			activeObject.setCollidedWith(otherObject);
			otherObject.setCollidedWith(activeObject);
			var p:Player = null;
//			var a:Arrow = null;
//			var explosion:Explosion = null
			var activeBoxPrev:Rectangle = activeObject.hitboxPrev;
			var otherBoxPrev:Rectangle = otherObject.hitboxPrev;
			var activeBoxCurr:Rectangle = activeObject.hitbox;
			var otherBoxCurr:Rectangle = otherObject.hitbox;

			//NOTE: just because this method was called, it doesn't mean that there was a collision
			//^^^ what????

			// get dirction of collision
			var direction:uint = Direction.determineDirection(activeObject, otherObject, activeBoxPrev, otherBoxPrev, activeBoxCurr, otherBoxCurr);
			if (direction == Direction.NONE)
				return;

			//EVERYTHING BELOW THIS LINE IS DEFINITELY A COLLISION

			if (activeObject is Player) {
				p = Player(activeObject);
			}

			/*
			* PLAYER GRABS COLLECTABLE
			*/
			if (p && otherObject is Collectable) {
				toRemove(otherObject);
				level.grabbedCollectable();
				coin.play();
			}
			/*
			* PLAYER ENTERS ACTIVE PORTAL
			*/
			if (p && otherObject is FinishLine && FinishLine(otherObject).canWin()) {
				level.onWonGame();
			}

			/*
			 * HANDLE DESTRUCTIONS
			 */
			if (activeObject.canDestroy(otherObject)) {
				toRemove(otherObject);
			}
			if (otherObject.canDestroy(activeObject)) {
				toRemove(activeObject);
			}
			if (otherObject.isSolid() && activeObject.isDestroyedBy(Destruction.ANY_SOLID_OBJECT)) {
				toRemove(activeObject);
			}
			if (activeObject.isSolid() && otherObject.isDestroyedBy(Destruction.ANY_SOLID_OBJECT)) {
				toRemove(otherObject);
			}

			/*
			* SOLID COLLISIONS
			*/
			if (activeObject.isSolid() && otherObject.isSolid()) {
				//handle directions:
				if (direction == Direction.DOWN) {
					activeObject.newY = otherBoxPrev.top - activeBoxCurr.height;
					activeObject.speedY = 0;
					if (otherObject.isDestroyedBy(Destruction.FALLING_SOLID_OBJECTS) && !otherObject.canDestroy(activeObject)) {
						toRemove(otherObject);
					} else if (p) { // player lands on object
						p.isStanding = true;
					} else { // something else lands on object
						deactivateObjects.push(activeObject);
					}
				} else if (direction == Direction.UP) {
					if (otherObject.isActive) {
						if (activeObject.isDestroyedBy(Destruction.FALLING_SOLID_OBJECTS) && !activeObject.canDestroy(otherObject)) {
							toRemove(activeObject);
						} else {
							otherObject.newY = activeBoxCurr.top - otherBoxCurr.height;
							otherObject.speedY = 0;
						}
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

			/*
			* KNOCKBACK
			*
			* TODO: use getKnockback, rather than constants?
			*/
			if (p && otherObject.getKnockback() > 0) {
				if (direction == Direction.DOWN) {
					activeObject.speedY = Player.KNOCKBACK_JUMP_SPEED;
				} else if (direction == Direction.UP) {
					activeObject.speedY = 0;
				} else if (direction == Direction.RIGHT) {
					activeObject.speedX = -Player.KNOCKBACK_HORIZONTAL;
				} else if (direction == Direction.LEFT) {
					activeObject.speedX = Player.KNOCKBACK_HORIZONTAL;
				}
			}

			activeObject.updateHitBox();
		}

		/**
		 * Called whenever an object is meant to die this frame.
		 */
		private function toRemove(obj:GameObject):void {
			if (removalObjects.indexOf(obj) == -1) {
				removalObjects.push(obj);
			}
		}

		/**
		 * Handle all of the objects that are meant to be destroyed
		 * or deactivated this frame.
		 */
		public function handleRemovals(camera:Sprite):void {
			for (var i:int = 0; i < removalObjects.length; i++) {
				var r:CollidableObject = CollidableObject(removalObjects[i]);

				if (!(r is Player))
					camera.removeChild(r);

				destroyObject(r);
			}
			removalObjects = new Array();

			for (i = 0; i < deactivateObjects.length; i++) {
				r = CollidableObject(deactivateObjects[i]);

				var index:int = activeObjects.indexOf(r);
				if (index != -1) {
					activeObjects.splice(index, 1);
				}

				r.isActive = false;
				updateObject(r, true);
			}
			deactivateObjects = new Array();
		}

		/**
		 * Called by handleRemovals, when destroying objects
		 * at the end of each game loop.
		 */
		private function destroyObject(obj:CollidableObject):void {
			if (obj.isActive) {
				//remove from active objects
				var index:int = activeObjects.indexOf(obj);
				if (index != -1) {
					activeObjects.splice(index, 1);
				}
			} else {
				//unblock neighbors
				var tile:GridTile = obj.myCollisionGridTiles[0];
				updateBlockedNeighbors(tile.gridRow, tile.gridCol);

				//activate all above tiles
				while (true) {
					if (inBounds(tile.gridRow - 1, tile.gridCol)) {
						tile = grid[tile.gridRow - 1][tile.gridCol];
						var toBreak:Boolean = !tile.isGravible();
						tile.activate();
						if (toBreak)
							break;
					} else {
						break;
					}
				}
			}
			obj.clearGrids();
			obj.onKillEvent(level);
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


