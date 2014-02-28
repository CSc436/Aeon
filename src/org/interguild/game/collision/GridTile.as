package org.interguild.game.collision {
	import flash.display.Sprite;

	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.CollidableObject;

	public class GridTile /*DEBUG*/extends Sprite /*END DEBUG*/ {

		private var myStuff:Vector.<CollidableObject>;
		private var row:uint;
		private var col:uint;

		public function GridTile(r:uint, c:uint) {
			row = r;
			col = c;
			myStuff = new Vector.<CollidableObject>();
			/*DEBUG*/
			graphics.beginFill(0xCCCCCC, 0.5);
			graphics.drawRect(0, 0, 31, 31);
			graphics.endFill();
		/*END DEBUG*/
		}

		internal function get gridRow():uint {
			return row;
		}

		internal function get gridCol():uint {
			return col;
		}

		public function addObject(o:CollidableObject):void {
			myStuff.push(o);

			/*DEBUG*/
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 0.25);
			graphics.drawRect(0, 0, 31, 31);
			graphics.endFill();
		/*END DEBUG*/
		}

		public function removeObject(o:CollidableObject):void {
			var i:int = myStuff.indexOf(o);
			if (i != -1)
				myStuff.splice(i, 1);
			if (!o.isActive && !isBlocking()) {
				Level.getMe().unblockNeighbors(this);
			}
			/*DEBUG*/
			graphics.clear();
			graphics.beginFill(0xCCCCCC, 0.5);
			graphics.drawRect(0, 0, 31, 31);
			graphics.endFill();
		/*END DEBUG*/
		}

		public function get myCollisionObjects():Vector.<CollidableObject> {
			return myStuff;
		}

		public function containsObject(o:CollidableObject):Boolean {
			var i:int = myStuff.indexOf(o);
			if (i == -1)
				return false;
			else
				return true;
		}

		/**
		 * Tells any inActive objects in this tile to block on the given Direction.
		 */
		public function block(direction:uint, unBlock:Boolean = false):void {
			var len:uint = myStuff.length;
			for (var i:uint = 0; i < len; i++) {
				var o:CollidableObject = myStuff[i];
				if (!o.isActive) {
					if (unBlock)
						o.setUnblocked(direction);
					else
						o.setBlocked(direction);
				}
			}
		}

		public function unblock(direction:uint):void {
			block(direction, true);
		}

		public function isBlocking():Boolean {
			var len:uint = myStuff.length;
			for (var i:uint = 0; i < len; i++) {
				var o:CollidableObject = myStuff[i];
				if (!o.isActive)
					return true;
			}
			return false;
		}
	}
}
