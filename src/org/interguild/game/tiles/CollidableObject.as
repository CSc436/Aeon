package org.interguild.game.tiles {
	import flash.geom.Rectangle;

	import org.interguild.game.collision.GridTile;

	/**
	 * Treat this class as an abstract class. It provides the
	 * general purpose interface for handling collision detection.
	 * This class is in charge of working with CollisionGrid to
	 * maintain a list of which GridTiles it's currently in so
	 * that the GameObject may remove itself from GridTiles that
	 * it is no longer inside of.
	 */
	public class CollidableObject extends GameObject {

		private var myGrids:Vector.<GridTile>;
		private var hit_box:Rectangle;

		/**
		 * DO NOT INSTANTIATE THIS CLASS. Please instantiate
		 * a subclass instead.
		 */
		public function CollidableObject(width:Number, height:Number) {
			myGrids = new Vector.<GridTile>();
			hit_box = new Rectangle(0, 0, width, height);
		}

		/**
		 * Remembers which GridTiles the GameObject is
		 * currently in.
		 */
		public function addGridTile(g:GridTile):void {
			myGrids.push(g);
		}

		/**
		 * It's dangerous to do collision detection alone.
		 * Take this. 
		 */
		public function get hitbox():Rectangle {
			hit_box.x = x;
			hit_box.y = y;
			return hit_box;
		}

		/**
		 * Removes the GameObject from all of the collision
		 * grid tiles that it is currently in.
		 */
		public function clearGrids():void {
			var len:uint = myGrids.length;
			for (var i:uint = 0; i < len; i++) {
				GridTile(myGrids[i]).removeObject(this);
			}
		}
	}
}
