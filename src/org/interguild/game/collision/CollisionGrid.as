package org.interguild.game.collision {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import org.interguild.Aeon;
	import org.interguild.INTERGUILD;
	import org.interguild.game.Player;
	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.Arrow;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.Explosion;
	import org.interguild.game.tiles.FinishLine;
	import org.interguild.game.tiles.GameObject;
	import org.interguild.game.tiles.SteelCrate;

	import org.interguild.game.tiles.Terrain;


	public class CollisionGrid extends Sprite {

		private var level:Level;
		private var grid:Array;
		private var jump:Sound;
		private var coin:Sound;

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
			
			jump = new Sound();
			jump.load(new URLRequest(INTERGUILD.ORG + "/aeon_demo/jump.mp3")); //remote
//			jump.load(new URLRequest("../assets/jump.mp3")); //local
			coin = new Sound();
			coin.load(new URLRequest(INTERGUILD.ORG + "/aeon_demo/coin.mp3")); //remote
//			coin.load(new URLRequest("../assets/coin.mp3")); //local

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
			if(o is FinishLine){
				level.setFinish(FinishLine(o));
			}
		}

		private function getDistance(obj1:CollidableObject, obj2:CollidableObject):Number {
			var center1:Point = new Point(obj1.hitboxPrev.x + obj1.hitboxPrev.width / 2, obj1.hitboxPrev.y + obj1.hitboxPrev.height / 2);
			var center2:Point = new Point(obj2.hitboxPrev.x + obj2.hitboxPrev.width / 2, obj2.hitboxPrev.y + obj2.hitboxPrev.height / 2);
			var distx:Number = center2.x - center1.x;
			var disty:Number = center2.y - center1.y;

			return Math.sqrt((distx * distx) + (disty * disty));
		}

		private function getSlope(p1:Point, p2:Point):Number {
			return (p2.y - p1.y) / (p2.x - p1.x);
		}

		/**
		 * Handle collisions!
		 */
		public function detectAndHandleCollisions(target:CollidableObject):Array {
			if(target is Explosion){
				var e:Explosion = Explosion(target);
				if(e.timeCounter >= 15 && removalObjects.indexOf(target) == -1)
					removalObjects.push(target);
			}
			
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
						//if potential corner collision
						if (!target.hitbox.intersects(obj.hitbox)) {
							distance = 0;
						}

						var toInsert:Array = new Array(distance, obj, obj.isActive);

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
							} else if ((!obj.isActive && objectsToTest[k][2]) || (distance < objectsToTest[k][0] && obj.isActive == objectsToTest[k][2])) {
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
				CONFIG::DEBUG {
					if (level.isDebuggingMode)
						trace(other, "x: " + other.x, "y: " + other.y, "dist: " + objectsToTest[m][0]);
				}

				if (!target.hasCollidedWith(other) && target.hitboxWrapper.intersects(other.hitboxWrapper)) {
					CONFIG::DEBUG {
						if (level.isDebuggingMode)
							trace("	handling collision");
					}
					//if they are colliding:
					handleCollision(target, other);
				}
			}
			CONFIG::DEBUG {
				if (level.isDebuggingMode)
					trace("-----------------------");
			}
			return removalObjects;
		}

		private function determineDirection(activeObject:CollidableObject, otherObject:CollidableObject, activeBoxPrev:Rectangle, otherBoxPrev:Rectangle, activeBoxCurr:Rectangle, otherBoxCurr:Rectangle):uint {
			if (activeBoxCurr.intersects(otherBoxPrev) || otherBoxCurr.intersects(activeBoxPrev)) {
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
				// backup testing
				var intsec:Rectangle;
				if (activeBoxCurr.intersects(otherBoxPrev))
					intsec = activeBoxCurr.intersection(otherBoxPrev);
				else
					intsec = otherBoxCurr.intersection(activeBoxPrev);
				if (intsec.width > intsec.height) {
					if (intsec.y > activeBoxCurr.y + activeBoxCurr.height / 2)
						return Direction.DOWN;
					else
						return Direction.UP;
				} else {
					if (intsec.x > activeBoxCurr.x + activeBoxCurr.width / 2)
						return Direction.RIGHT;
					else
						return Direction.LEFT;
				}
			} else {
				/*
				 * COMPLICATED CORNER CASES
				 */
				var slopeSelf:Number;
				var slopeOther:Number
				var basePoint:Point;
				var selfPoint:Point;
				var otherPoint:Point;
				//going down-right	//compare top-right point to bottom-left point
				if (activeBoxPrev.top <= otherBoxPrev.bottom && activeBoxCurr.top >= otherBoxCurr.bottom && activeBoxPrev.right <= otherBoxPrev.left && activeBoxCurr.right >= otherBoxCurr.left) {
					basePoint = new Point(activeBoxPrev.right, activeBoxPrev.top);
					selfPoint = new Point(activeBoxCurr.right, activeBoxCurr.top);
					otherPoint = new Point(otherBoxCurr.left, otherBoxCurr.bottom);
					slopeSelf = getSlope(basePoint, selfPoint);
					slopeOther = getSlope(basePoint, otherPoint);
					if (slopeSelf <= slopeOther) {
//						trace("CORNER CASE: on down-right");
						return Direction.RIGHT;
					}
						//going down-left //compare top-left point to bottom-right point
				} else if (activeBoxPrev.top <= otherBoxPrev.bottom && activeBoxCurr.top >= otherBoxCurr.bottom && activeBoxPrev.left <= otherBoxPrev.right && activeBoxCurr.left <= otherBoxCurr.right) {
					basePoint = new Point(activeBoxPrev.left, activeBoxPrev.top);
					selfPoint = new Point(activeBoxCurr.left, activeBoxCurr.top);
					otherPoint = new Point(otherBoxCurr.right, otherBoxCurr.bottom);
					slopeSelf = getSlope(basePoint, selfPoint);
					slopeOther = getSlope(basePoint, otherPoint);
					if (slopeSelf <= slopeOther) {
//						trace("CORNER CASE: on down-left");
						return Direction.LEFT;
					}
						//going up-left //compare bottom-left point to top-right point
				} else if (activeBoxPrev.bottom >= otherBoxPrev.top && activeBoxCurr.bottom <= otherBoxCurr.top && activeBoxPrev.left >= otherBoxPrev.right && activeBoxCurr.left <= otherBoxCurr.right) {
					basePoint = new Point(activeBoxPrev.left, activeBoxPrev.bottom);
					selfPoint = new Point(activeBoxCurr.left, activeBoxCurr.bottom);
					otherPoint = new Point(otherBoxCurr.right, otherBoxCurr.top);
					slopeSelf = getSlope(basePoint, selfPoint);
					slopeOther = getSlope(basePoint, otherPoint);
					if (slopeSelf >= slopeOther) {
//						trace("CORNER CASE: on up-left");
						return Direction.LEFT;
					}
						//going up-right //compare bottom-right point to top-left point
				} else if (activeBoxPrev.bottom >= otherBoxPrev.top && activeBoxCurr.bottom <= otherBoxCurr.top && activeBoxPrev.right <= otherBoxPrev.left && activeBoxCurr.right >= otherBoxCurr.left) {
					basePoint = new Point(activeBoxPrev.right, activeBoxPrev.bottom);
					selfPoint = new Point(activeBoxCurr.right, activeBoxCurr.bottom);
					otherPoint = new Point(otherBoxCurr.left, otherBoxCurr.top);
					slopeSelf = getSlope(basePoint, selfPoint);
					slopeOther = getSlope(basePoint, otherPoint);
					if (slopeSelf >= slopeOther) {
//						trace("CORNER CASE: on up-right");
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
			var a:Arrow = null;
			var explosion:Explosion = null
			var activeBoxPrev:Rectangle = activeObject.hitboxPrev;
			var otherBoxPrev:Rectangle = otherObject.hitboxPrev;
			var activeBoxCurr:Rectangle = activeObject.hitbox;
			var otherBoxCurr:Rectangle = otherObject.hitbox;

			//NOTE: just because this method was called, it doesn't mean that there was a collision

			// get dirction of collision
			var direction:uint = determineDirection(activeObject, otherObject, activeBoxPrev, otherBoxPrev, activeBoxCurr, otherBoxCurr);
			if (direction == Direction.NONE)
				return;

			if (activeObject is Player) {
				p = Player(activeObject);
			}
			// Check to see if arrow is the culprit
			if (activeObject is Arrow) {
				a = Arrow(activeObject);
			}
			// Check to see if explosion is the culprit
			if (activeObject is Explosion) {
				explosion = Explosion(activeObject);
			}
			if (!(otherObject is CollidableObject) || !(activeObject is CollidableObject)) {
				//will never ever happen
				throw new Error("Please handle non-CollidableObjects in special cases before this line.");
			}
			
//			trace("Object 1: "+activeObject.toString());
//			trace("Object 2: "+otherObject.toString());

			var activeTile:CollidableObject = CollidableObject(activeObject);
			var otherTile:CollidableObject = CollidableObject(otherObject);
			
			/*
			* PLAYER HIT BY ARROW
			*/
			if(p && otherTile is Arrow){
				p.die();
				removalObjects.push(p);
			}
			
			if(p && otherTile is Explosion){
				p.die();
				removalObjects.push(p);
			}
			
			/*
			* EXPLOSION DESTROYS SURROUNDINGS
			*/
			if ((explosion && !(otherTile is Collectable || otherTile is Terrain || otherTile is Explosion || otherTile is Arrow))) {
				removalObjects.push(otherObject);
//				var m:MovieClip = MovieClip(explosion.exp);
//				m.play();
				if (explosion.timeCounter >= 15 && removalObjects.indexOf(activeObject) == -1)
					removalObjects.push(activeObject);
			}
			else if (explosion && explosion.timeCounter >= 15 && removalObjects.indexOf(activeObject) == -1)
				removalObjects.push(activeObject);
			
			/*
			* ARROW HITS CRATE
			*/
			if ((a && otherTile.getDestructibility() == 2) || (a && otherTile is SteelCrate)) {
				removalObjects.push(otherObject);
				removalObjects.push(activeObject);
			}
			else if (a && otherTile.getDestructibility() == 0) 
				removalObjects.push(activeObject);
			/*
			* PLAYER GRABS COLLECTABLE
			*/
			if (p && otherObject is Collectable) {
				removalObjects.push(otherObject);
				level.grabbedCollectable();
				coin.play(0);
				
				if(level.grabbedAll()){
					level.openPortal();
				}
				/*
				* PLAYER ENTERS ACTIVE PORTAL
				*/
			} else if (p && otherObject is FinishLine && FinishLine(otherObject).canWin()) {
				level.onWonGame();
				/*
				* PLAYER HITS CRATE
				*/
			} else if (p && otherTile.getDestructibility() == 2) {
				// knockback stuff:
				if (otherTile.doesKnockback() > 0) {
					if (direction == Direction.DOWN) {
						p.speedY = Player.KNOCKBACK_JUMP_SPEED;						
						jump.play(100);
					} else if (direction == Direction.UP) {
						activeObject.speedY = 0;
					} else if (direction == Direction.RIGHT) {
						activeObject.speedX = -Player.KNOCKBACK_HORIZONTAL;
					} else if (direction == Direction.LEFT) {
						activeObject.speedX = Player.KNOCKBACK_HORIZONTAL;
					}
				}
				removalObjects.push(otherObject);
			}
		
			/*
			* SOLID COLLISIONS
			*/
			else if (activeTile.isSolid() && otherTile.isSolid()) {
				if (direction == Direction.DOWN) {
					activeObject.newY = otherBoxPrev.top - activeBoxCurr.height;
					activeObject.speedY = 0;
					if (p) {
						p.isStanding = true;
					} else if (otherObject is Player) { //player got crushed by falling solid object
						trace("p = other");
						Player(otherObject).die();
							//return;
					} else {
						deactivateObjects.push(activeObject);
					}
				} else if (direction == Direction.UP) {
					if (otherTile.isActive) {
						otherObject.newY = activeBoxCurr.top - otherBoxCurr.height;
						otherObject.speedY = 0;
						if (p) { //player got crushed by falling solid object
							trace("p = active");
							p.die();
								//return;
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
			
			
			activeObject.updateHitBox();
		}

		public function handleRemovals(camera:Sprite):void {
			for (var i:int = 0; i < removalObjects.length; i++) {
				var r:GameObject = GameObject(removalObjects[i]);

				//remove from display list
				camera.removeChild(DisplayObject(r));

				//remove from grid tiles
				if (r is CollidableObject) {
					destroyObject(CollidableObject(r));
				}
			}
			removalObjects = new Array();

			for (i = 0; i < deactivateObjects.length; i++) {
				r = GameObject(deactivateObjects[i]);

				var index:int = activeObjects.indexOf(r);
				if (index != -1) {
					activeObjects.splice(index, 1);
				}

				if (r is CollidableObject) {
					var c:CollidableObject = CollidableObject(r);
					c.isActive = false;
					updateObject(c, true);
				}
			}
			deactivateObjects = new Array();
		}

		public function destroyObject(obj:CollidableObject):void {
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
					}else{
						break;
					}
				}
			}
			obj.clearGrids();
			obj.onKillEvent(level);

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
