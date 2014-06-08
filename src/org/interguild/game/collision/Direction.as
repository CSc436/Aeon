package org.interguild.game.collision {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.Platform;

	public class Direction {

		public static const NONE:uint = 0;
		public static const UP:uint = 1;
		public static const RIGHT:uint = 2;
		public static const DOWN:uint = 3;
		public static const LEFT:uint = 4;

		/**
		 * Determines the direction that the two objects collided in.
		 */
		public static function determineDirection(activeObject:CollidableObject, otherObject:CollidableObject, activeBoxPrev:Rectangle, otherBoxPrev:Rectangle, activeBoxCurr:Rectangle, otherBoxCurr:Rectangle):uint {
			var dir:uint;
			if (activeBoxCurr.intersects(otherBoxPrev) || otherBoxCurr.intersects(activeBoxPrev)) {
				dir = simpleDirection(activeObject, otherObject, activeBoxPrev, otherBoxPrev, activeBoxCurr, otherBoxCurr);
				if (dir == Direction.NONE && !(otherObject is Platform))
					return simpleBackupDirection(activeObject, otherObject, activeBoxPrev, otherBoxPrev, activeBoxCurr, otherBoxCurr);
				else
					return dir;
			} else {
				return cornerCaseDirection(activeObject, otherObject, activeBoxPrev, otherBoxPrev, activeBoxCurr, otherBoxCurr);
			}
			return Direction.NONE;
		}

		/**
		 * Simple, one-direction, collision cases.
		 */
		private static function simpleDirection(activeObject:CollidableObject, otherObject:CollidableObject, activeBoxPrev:Rectangle, otherBoxPrev:Rectangle, activeBoxCurr:Rectangle, otherBoxCurr:Rectangle):uint {
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
			return Direction.NONE;
		}

		/**
		 * Still couldn't figure out which direction it was?
		 * Here's a crude way of guessing what it was.
		 */
		private static function simpleBackupDirection(activeObject:CollidableObject, otherObject:CollidableObject, activeBoxPrev:Rectangle, otherBoxPrev:Rectangle, activeBoxCurr:Rectangle, otherBoxCurr:Rectangle):uint {
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
		}

		/**
		 * Complicated corner cases
		 */
		private static function cornerCaseDirection(activeObject:CollidableObject, otherObject:CollidableObject, activeBoxPrev:Rectangle, otherBoxPrev:Rectangle, activeBoxCurr:Rectangle, otherBoxCurr:Rectangle):uint {
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
					//					trace("CORNER CASE: on down-right");
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
					//					trace("CORNER CASE: on down-left");
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
					//					trace("CORNER CASE: on up-left");
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
					//					trace("CORNER CASE: on up-right");
					return Direction.RIGHT;
				}
			}
			return Direction.NONE;
		}

		private static function getSlope(p1:Point, p2:Point):Number {
			return (p2.y - p1.y) / (p2.x - p1.x);
		}
	}
}
