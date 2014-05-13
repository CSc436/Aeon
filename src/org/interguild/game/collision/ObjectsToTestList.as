package org.interguild.game.collision {

	/**
	 * A priority-list of which nearby CollidableObjects to
	 * test collisions on. Elements are ordered based on
	 * proximity and their potential to be a corner case.
	 */
	public class ObjectsToTestList {

		private var list:Array;

		private var i:uint = 0;

		public function ObjectsToTestList() {
			list = new Array();
		}

		public function insertInOrder(obj:ObjectsToTestEntry):void {
			var alen:uint = list.length;
			var tmp:ObjectsToTestEntry = null;
			for (var k:uint = 0; k < alen; k++) {
				var curObj:ObjectsToTestEntry = ObjectsToTestEntry(list[k]);
				//shifting elements down the array
				if (tmp != null) {
					var tmp2:ObjectsToTestEntry = list[k];
					list[k] = tmp;
					tmp = tmp2;
						// if to be inserted at this location
				} else if (obj.comesBefore(curObj)) {
					tmp = curObj;
					list[k] = obj;
				}
			}
			//finish shifting elements
			if (tmp != null) {
				list[list.length] = tmp;
					//or insert element to end
			} else {
				list[list.length] = obj;
			}
		}

		/**
		 * Prepares the list to be iterated through
		 */
		public function prepareToIterate():void {
			i = 0;
		}

		public function hasNext():Boolean {
			return i < list.length;
		}

		public function next():ObjectsToTestEntry {
			i++;
			return list[i - 1];
		}
	}
}
