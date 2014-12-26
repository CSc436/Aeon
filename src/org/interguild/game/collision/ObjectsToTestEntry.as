package org.interguild.game.collision {
	import org.interguild.game.tiles.CollidableObject;

	public class ObjectsToTestEntry {

		private var dist:Number;
		private var obj:CollidableObject;

		public function ObjectsToTestEntry(distance:Number, object:CollidableObject) {
			dist = distance;
			obj = object;
		}

		public function get isActive():Boolean {
			return obj.isActive;
		}

		public function get isSolid():Boolean {
			return obj.isSolid();
		}

		public function get distance():Number {
			return dist;
		}

		public function get object():CollidableObject {
			return obj;
		}

		public function comesBefore(other:ObjectsToTestEntry):Boolean {
			return (this.isSolid && !other.isSolid) || (this.distance < other.distance && this.isSolid == other.isSolid);
//			return this.distance < other.distance;
		}
	}
}
