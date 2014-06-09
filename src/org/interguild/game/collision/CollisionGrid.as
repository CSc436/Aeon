package org.interguild.game.collision {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.interguild.SoundMan;
	import org.interguild.game.Level;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.DynamiteWoodCrate;
	import org.interguild.game.tiles.Explosion;
	import org.interguild.game.tiles.FinishLine;
	import org.interguild.game.tiles.GameObject;
	import org.interguild.game.tiles.Platform;
	import org.interguild.game.tiles.Player;
	import org.interguild.game.tiles.SecretArea;

	public class CollisionGrid extends Sprite {

		private var level:Level;
		private var grid:Array;

		private var player:Player;
		private var allObjects:Array;
		private var activeObjects:Array;

		private var delays:DelayManager;
		private var deactivateObjects:Array;

		private var sounds:SoundMan;

		public function CollisionGrid(width:int, height:int, level:Level) {
			this.level = level;
			sounds = SoundMan.getMe();
			deactivateObjects = new Array();
			delays = new DelayManager();

			//init lists
			allObjects = new Array;
			activeObjects = new Array;

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

		/**
		 * Helps garbage collection to clear some references.
		 */
		public function deconstruct():void {
			var rows:uint = grid.length;
			var cols:uint = grid[0].length;
			for (var r:uint = 0; r < rows; r++) {
				for (var c:uint = 0; c < cols; c++) {
					GridTile(grid[r][c]).deconstruct();
					grid[r][c] = null;
				}
			}
			grid = null;
			allObjects = null;
			activeObjects = null;
			deactivateObjects = null;
			player = null;
			delays = null;
		}

		public function setPlayer(p:Player):void {
			player = p;
		}

		/**
		 * Given a certain GridTile's coordinates, returns true if that
		 * tile should force the player to crawl. This function is called
		 * by Player during its onGameLoop() funciton.
		 */
		public function needToCrawl(r:uint, c:uint):Boolean {
			if (!inBounds(r, c))
				return false;

			var tile:GridTile = grid[r][c];
			return tile.needToCrawl();
		}

		/**
		 * Are the given GridTile coordinates within range of our 2D array?
		 */
		private function inBounds(row:int, col:int):Boolean {
			return (row >= 0 && row < grid.length && col >= 0 && col < grid[0].length);
		}

		/**
		 * Called during initialization, when objects are being added to the game.
		 */
		public function addObject(tile:CollidableObject, fakeObject:Boolean):void {
			allObjects.push(tile);
			if (tile.isActive)
				activeObjects.push(tile);
			if (!fakeObject)
				updateObject(tile, !tile.isActive);
		}

		/**
		 * Adds the object to its correct GridTiles. This should be called during
		 * initialization and whenever the object's onGameLoop() function is called.
		 *
		 * If blockNeighbors is set to true, will notify the four adjacent tiles that
		 * they are now blocked on that side, so they shouldn't bother testing for
		 * collisions there. BlockNeighbors assumes that you only take up one grid tile.
		 */
		public function updateObject(o:CollidableObject, blockNeighbors:Boolean):void {
			var box:Rectangle = o.hitbox;
			var gridTile:GridTile;

			var top:int = box.top / 32;
			var left:int = box.left / 32;
			var bottom:int = (box.bottom - 1) / 32;
			var right:int = (box.right - 1) / 32;
			if (o == player) {
				top--;
				left--;
				bottom++;
				right++;
			}

			//remove old grids
			o.clearGrids();

			//add new grids
			for (var row:int = top; row <= bottom; row++) {
				if (row >= 0 && row < grid.length) {
					for (var col:int = left; col <= right; col++) {
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

			if (!o.isInGridTiles()) {
				delays.onDeath(o);
			}
		}

		/**
		 * Given an object at a given GridTile coordinate, will block the
		 * surrounding four tiles so that they know that it's not worth
		 * testing for collisions along that side. This is useful during
		 * initialization of inactive objects or during deactivations.
		 * 
		 * Leave the third parameter null to unblock, which is useful during
		 * object destruction or activations.
		 * 
		 * This function is labeled internal because GridTile objects often
		 * call it.
		 */
		internal function updateBlockedNeighbors(row:int, col:int, o:CollidableObject = null):void {
			var gridTile:GridTile;

			//top
			var bx:int = col;
			var by:int = row - 1;
			var isNotPlatform:Boolean = !(o is Platform);
			if (inBounds(by, bx)) {
				gridTile = grid[by][bx];
				if (o) {
					if (isNotPlatform)
						gridTile.block(Direction.DOWN);
					if (gridTile.isBlocking())
						o.setBlocked(Direction.UP);
				} else {
					gridTile.unblock(Direction.DOWN);
				}
			}

			//down
			by = row + 1;
			if (inBounds(by, bx)) {
				gridTile = grid[by][bx];
				if (o) {
					if (isNotPlatform)
						gridTile.block(Direction.UP);
					if (gridTile.isBlocking())
						o.setBlocked(Direction.DOWN);
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
					if (isNotPlatform)
						gridTile.block(Direction.LEFT);
					if (gridTile.isBlocking())
						o.setBlocked(Direction.RIGHT);
				} else {
					gridTile.unblock(Direction.LEFT);
				}
			}

			//left
			bx = col - 1;
			if (inBounds(by, bx)) {
				gridTile = grid[by][bx];
				if (o) {
					if (isNotPlatform)
						gridTile.block(Direction.RIGHT);
					if (gridTile.isBlocking())
						o.setBlocked(Direction.LEFT);
				} else {
					gridTile.unblock(Direction.RIGHT);
				}
			}
		}

		/**
		 * Updates all active objects, calling their onGameLoop() function
		 * and updating their current position in the Collision Grid Tiles.
		 */
		public function updateAllObjects():void {
			//update player
			player.onGameLoop();
			if (!player.isDead) {
				updateObject(player, false);
			}

			//update active objects
			var len:uint = activeObjects.length;
			for (var i:uint = 0; i < len; i++) {
				var obj:CollidableObject = activeObjects[i];
				obj.onGameLoop();
				updateObject(obj, false);
				if (obj is Explosion) {
					var e:Explosion = Explosion(obj);
					if (e.timeCounter >= 15)
						delays.onDeath(e);
				}
			}
		}

		/**
		 * Your one-stop function for if you want collision detection done.
		 *
		 * We need to resolve these collisions in a very specific order in
		 * order to avoid the need to rollback collision resolutions. On a
		 * high level, the order is as follows:
		 * 	 [] PLAYER vs INACTIVE object collisions
		 * 	 [] other ACTIVE objects vs INACTIVE object collisions
		 * 	 [] PLAYER vs ACTIVE object collisions
		 * 	 [] other ACTIVE objects vs ACTIVE object collisions
		 * Each of these groups are then prioritized further based on
		 * proximity and likelihood of being a significant collision.
		 */
		public function doCollisionDetection():void {
			//gather all collision pairs
			var inactiveLists:Array = [];
			var activeLists:Array = [];
			var onInactive:ObjectsToTestList;
			var onActive:ObjectsToTestList;

			//gather player's pairs
			if (!player.isDead) {
				onInactive = new ObjectsToTestList(player);
				onActive = new ObjectsToTestList(player);
				gatherNearbyPairs(onActive, onInactive, player);
				inactiveLists.push(onInactive);
				activeLists.push(onActive);
			}

			//gather everyone else's pairs
			var len:uint = activeObjects.length;
			for (var i:uint = 0; i < len; i++) {
				var obj:CollidableObject = activeObjects[i];
				onInactive = new ObjectsToTestList(obj);
				onActive = new ObjectsToTestList(obj);
				gatherNearbyPairs(onActive, onInactive, obj);
				inactiveLists.push(onInactive);
				activeLists.push(onActive);
			}

			//test all of these pairs in order
			testCollisionPairs(inactiveLists);
			testCollisionPairs(activeLists);
		}

		/**
		 * This function gathers all of the objects that are within range
		 * of the target object. It then adds each object to either the
		 * given activeList or the given inactiveList, which will intern
		 * prioritize the objects based on proximity and other things.
		 */
		private function gatherNearbyPairs(activeList:ObjectsToTestList, inactiveList:ObjectsToTestList, target:CollidableObject):void {
			var gTiles:Array = target.myCollisionGridTiles;
			var len:uint = gTiles.length;
			//iterate through all of the Collision GridTiles that the target is in
			for (var i:uint = 0; i < len; i++) {
				var tile:GridTile = gTiles[i];
				var gObjs:Array = tile.myCollisionObjects;
				var olen:uint = gObjs.length;
				//interate through all of the objects in each GridTile
				for (var j:uint = 0; j < olen; j++) {
					var obj:CollidableObject = gObjs[j];
					if (target != obj && !(target == player && obj is SecretArea)) {
						var distance:Number = getDistance(obj, target);
						//if potential corner collision
						if (!target.hitbox.intersects(obj.hitbox)) {
							distance = 0;
						}
						if (obj.isActive)
							activeList.insertInOrder(new ObjectsToTestEntry(distance, obj));
						else
							inactiveList.insertInOrder(new ObjectsToTestEntry(distance, obj));
					}
				}
			}
		}

		/**
		 * Returns the proximity of the two objects. Used by gatherNearbyPairs();
		 */
		private function getDistance(obj1:CollidableObject, obj2:CollidableObject):Number {
			var center1:Point = new Point(obj1.hitboxPrev.x + obj1.hitboxPrev.width / 2, obj1.hitboxPrev.y + obj1.hitboxPrev.height / 2);
			var center2:Point = new Point(obj2.hitboxPrev.x + obj2.hitboxPrev.width / 2, obj2.hitboxPrev.y + obj2.hitboxPrev.height / 2);
			var distx:Number = center2.x - center1.x;
			var disty:Number = center2.y - center1.y;

			return Math.sqrt((distx * distx) + (disty * disty));
		}

		/**
		 * Given an Array of ObjectsToTestList objects, it will iterate through
		 * all of the object pairs and resolve the collisions. We wait until this
		 * step to finally determine whether or not the objects even intercept
		 * because previous collision resolutions might have finally caused the
		 * intersection.
		 */
		private function testCollisionPairs(list:Array):void {
			//iterate through Array of ObjectsToTestLists
			var len:uint = list.length;
			for (var i:uint = 0; i < len; i++) {
				var objectsToTest:ObjectsToTestList = list[i];
				var target:CollidableObject = objectsToTest.target;
				//iterate through the ObjectsToTestList
				objectsToTest.prepareToIterate();
				while (objectsToTest.hasNext()) {
					var other:CollidableObject = objectsToTest.next();

					// HACKY STUFF BELOW //
					if ((target == player || other == player) && player.isDead)
						continue;
					// HACKY STUFF ABOVE //

					if (!target.hasCollidedWith(other) && target.hitboxWrapper.intersects(other.hitboxWrapper)) {
						handleCollision(target, other);
					}
				}
			}
		}

		/**
		 * This is where the magic happens, where all of the logic for collision
		 * resolution is.
		 *
		 * Because of the tricky corner-case-collisions, when this function is
		 * called, it doesn't necessarily mean that there was a collision. That
		 * is determined when we call Direction.determineDirection(), which
		 * returns NONE if there was no collision.
		 *
		 * This function is broken up into a series of stages, which could
		 * probably be broken up into smaller functions but aren't because
		 * it's simply easier to modify the collision resolution logic when
		 * it's all together like this.
		 */
		private function handleCollision(activeObject:CollidableObject, otherObject:CollidableObject):void {
			activeObject.setCollidedWith(otherObject);
			otherObject.setCollidedWith(activeObject);
			var isPlayer:Boolean = activeObject == player;
			var isPlatform:Boolean = isPlayer && otherObject is Platform;
			var activeBoxPrev:Rectangle = activeObject.hitboxPrev;
			var otherBoxPrev:Rectangle = otherObject.hitboxPrev;
			var activeBoxCurr:Rectangle = activeObject.hitbox;
			var otherBoxCurr:Rectangle = otherObject.hitbox;

			// get dirction of collision
			var direction:uint = Direction.determineDirection(activeObject, otherObject, activeBoxPrev, otherBoxPrev, activeBoxCurr, otherBoxCurr);
			if (isPlatform && direction != Direction.DOWN && Platform(otherObject).countsCollision(activeObject, activeBoxCurr)) {
				direction = Direction.DOWN;
			}
			if (direction == Direction.NONE && !activeBoxCurr.intersects(otherBoxCurr))
				return;

			//EVERYTHING BELOW THIS LINE IS DEFINITELY A COLLISION

			if (isPlayer) {
				/*
				* PLAYER GRABS COLLECTABLE
				*/
				if (otherObject is Collectable) {
					delays.onDeath(otherObject);
					level.grabbedCollectable();
					sounds.playSound(SoundMan.TREASURE_COLLECT_SOUND);
					return;
				}

				/*
				* PLAYER ENTERS ACTIVE PORTAL
				*/
				if (otherObject is FinishLine && FinishLine(otherObject).canWin()) {
					level.onWonGame();
				}
			}

			/*
			 * HANDLE DESTRUCTIONS
			 */
			var destroyed:Boolean = false;
			if (activeObject.canDestroy(otherObject)) {
				if (isPlayer && otherObject is DynamiteWoodCrate) {
					DynamiteWoodCrate(otherObject).killedByPlayer(direction, activeBoxCurr);
				}
				delays.onDeath(otherObject);
				destroyed = true;
			}
			if (otherObject.canDestroy(activeObject)) {
				delays.onDeath(activeObject);
				destroyed = true;
			}
			if (otherObject.isSolid() && activeObject.isDestroyedBy(Destruction.ANY_SOLID_OBJECT)) {
				delays.onDeath(activeObject);
				destroyed = true;
			}
			if (activeObject.isSolid() && otherObject.isDestroyedBy(Destruction.ANY_SOLID_OBJECT)) {
				delays.onDeath(otherObject);
				destroyed = true;
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
						delays.onDeath(otherObject);
					} else if (isPlayer && !destroyed) { // player lands on object
						player.landedOnGround(otherBoxCurr.top);
					} else if (!isPlayer) { // something else lands on object
						deactivateObjects.push(activeObject);
					}
				} else if (direction == Direction.UP && !isPlatform) {
					if (otherObject.isActive) {
						if (activeObject.isDestroyedBy(Destruction.FALLING_SOLID_OBJECTS) && !activeObject.canDestroy(otherObject)) {
							delays.onDeath(activeObject);
						} else {
							otherObject.newY = activeBoxCurr.top - otherBoxCurr.height;
							otherObject.speedY = 0;
						}
					} else if (!(isPlayer && player.isStanding)) {
						activeObject.newY = otherBoxCurr.bottom;
						activeObject.speedY = 0;
					}
				} else if (direction == Direction.RIGHT && !isPlatform) {
					activeObject.newX = otherBoxCurr.left - activeBoxCurr.width;
					activeObject.speedX = 0;
				} else if (direction == Direction.LEFT && !isPlatform) {
					activeObject.newX = otherBoxCurr.right;
					activeObject.speedX = 0;
				}
			}

			/*
			* KNOCKBACK
			*
			* TODO: use getKnockback, rather than constants?
			*/
			if (isPlayer && otherObject.getKnockback() > 0) {
				if (direction == Direction.DOWN || (!player.isStanding && player.speedY > 0)) {
					activeObject.speedY = Player.KNOCKBACK_JUMP_SPEED;
				} else if (direction == Direction.UP || (!player.isStanding && player.speedY < 0)) {
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
		 * All object removals are handled directly after collision
		 * detection, so that it won't interfere with our attempts
		 * to iterate through our lists of objects.
		 *
		 * In addition to removals, we also need to handle activations
		 * and deactivations, because they both modify the activeObjects
		 * list.
		 *
		 * The Level class needs to pass us a reference to the cmaera
		 * so that we can remove it from the game world. This is kinda
		 * ugly design, so it might change soon.
		 */
		public function handleRemovalsAndMore(camera:Sprite):void {
			//removals:
			var removalObjects:Array = delays.getDeaths();
			for (var i:int = 0; i < removalObjects.length; i++) {
				var r:CollidableObject = CollidableObject(removalObjects[i]);
				if (r != player) {
					camera.removeChild(r);
				}
				destroyObject(r);
			}

			//deactivations:
			for (i = 0; i < deactivateObjects.length; i++) {
				r = CollidableObject(deactivateObjects[i]);

				var index:int = activeObjects.indexOf(r);
				if (index != -1) {
					activeObjects.splice(index, 1);
				}

				r.finishGameLoop();
				r.isActive = false;
				updateObject(r, true);
			}
			deactivateObjects = new Array();

			//activations:
			var toActivate:Array = delays.getActivations();
			for (i = 0; i < toActivate.length; i++) {
				var tile:GridTile = toActivate[i];
				var wasGravible:Boolean = tile.isGravible();
				tile.activate();
				//active the tile above
				if (wasGravible && inBounds(tile.gridRow - 1, tile.gridCol)) {
					delays.onActivate(grid[tile.gridRow - 1][tile.gridCol]);
				}
			}
		}

		/**
		 * Called by handleRemovalsAndMore, when destroying objects
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

				//activate tile above
				if (inBounds(tile.gridRow - 1, tile.gridCol)) {
					delays.onActivate(grid[tile.gridRow - 1][tile.gridCol]);
				}
			}
			obj.clearGrids();
			//call onKillEvent and get list of projectiles that the object threw
			var toActivate:Array = obj.onKillEvent(level);
			if (toActivate != null) {
				var len:uint = toActivate.length;
				for (var i:uint = 0; i < len; i++) {
					activateObject(toActivate[i]);
				}
			}
		}

		/**
		 * Called by GridTile when a tile is activated, or by destroyObject()
		 * when projectiles are thrown.
		 */
		public function activateObject(o:CollidableObject):void {
			o.isActive = true;
			activeObjects.push(o);
		}

		/**
		 * Calls every active object's finishGameLoop() function.
		 */
		public function finishGameLoops():void {
			player.finishGameLoop();
			var len:uint = activeObjects.length;
			for (var i:uint = 0; i < len; i++) {
				var obj:GameObject = activeObjects[i];
				obj.finishGameLoop();
			}
		}
	}
}


