package org.interguild.game.collision {

	import flash.display.Sprite;
	
	import org.interguild.game.tiles.CollidableObject;

	public class GridTile extends Sprite {

		private var myStuff:Vector.<CollidableObject>;
		private var row:uint;
		private var col:uint;
		private var grid:CollisionGrid;

		public function GridTile(r:uint, c:uint, g:CollisionGrid) {
			row = r;
			col = c;
			grid = g;
			mouseEnabled = false;
			myStuff = new Vector.<CollidableObject>();
			CONFIG::DEBUG {
				graphics.beginFill(0xCCCCCC, 0.5);
				graphics.drawRect(0, 0, 31, 31);
				graphics.endFill();
			}
		}
		
		public function deconstruct():void{
			myStuff = null;
			grid = null;
		}

		public function get gridRow():uint {
			return row;
		}

		public function get gridCol():uint {
			return col;
		}

		public function addObject(o:CollidableObject):void {
			myStuff.push(o);

			CONFIG::DEBUG {
				graphics.clear();
				graphics.beginFill(0xFFFFFF, 0.25);
				graphics.drawRect(0, 0, 31, 31);
				graphics.endFill();
			}
		}

		public function removeObject(o:CollidableObject):void {
			var i:int = myStuff.indexOf(o);
			if (i != -1)
				myStuff.splice(i, 1);
			if (!o.isActive && !isBlocking()) {
				grid.updateBlockedNeighbors(row, col);
			}
			CONFIG::DEBUG {
				graphics.clear();
				graphics.beginFill(0xCCCCCC, 0.5);
				graphics.drawRect(0, 0, 31, 31);
				graphics.endFill();
			}
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

		/**
		 * Wakes up the inActive objects in this grid. This method
		 * is called when a nearby object does something like move
		 */
		public function activate():void {
			var len:uint = myStuff.length;
			for (var i:uint = 0; i < len; i++) {
				var o:CollidableObject = myStuff[i];
				if (!o.isActive && o is CollidableObject && o.isGravible()) {
					o.isActive = true;
					grid.activeObjects.push(o);
				}
			}
			grid.updateBlockedNeighbors(row, col);
		}
		
		public function isGravible():Boolean{
			var len:uint = myStuff.length;
			for (var i:uint = 0; i < len; i++) {
				var o:CollidableObject = myStuff[i];
				if(o is CollidableObject && !o.isActive && o.isGravible())
					return true;
			}
			return false;
		}
	}
}
