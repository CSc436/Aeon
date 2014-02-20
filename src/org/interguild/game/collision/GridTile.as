package org.interguild.game.collision {
	import flash.display.Sprite;

	import org.interguild.game.tiles.CollidableObject;

	public class GridTile /*DEBUG*/extends Sprite /*END DEBUG*/ {

		private var myStuff:Vector.<CollidableObject>;

		public function GridTile() {
			myStuff=new Vector.<CollidableObject>();
			/*DEBUG*/
			graphics.beginFill(0xCCCCCC, 0.5);
			graphics.drawRect(0, 0, 31, 31);
			graphics.endFill();
		/*END DEBUG*/
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
			var i:int=myStuff.indexOf(o);
			if (i != -1)
				myStuff.splice(i, 1);
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
			var i:int=myStuff.indexOf(o);
			if (i == -1)
				return false;
			else
				return true;
		}
	}
}
