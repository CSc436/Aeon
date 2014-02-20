package org.interguild.game.tiles {
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
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
		private var hit_box_prev:Rectangle;
		private var justCollided:Dictionary;

		/**
		 * DO NOT INSTANTIATE THIS CLASS. Please instantiate
		 * a subclass instead.
		 */
		public function CollidableObject(_x:Number, _y:Number, width:Number, height:Number) {
			super(_x, _y);
			myGrids = new Vector.<GridTile>();
			hit_box = new Rectangle(_x, _y, width, height);
			hit_box_prev = hit_box.clone();
			justCollided = new Dictionary(true);
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
			hit_box.x = newX;
			hit_box.y = newY;
			return hit_box;
		}
		
		public function get hitboxPrev():Rectangle{
			return hit_box_prev;
		}
		
		public function setCollidedWith(obj:CollidableObject):void{
			justCollided[obj] = true;
		}
		
		public function hasCollidedWith(obj:CollidableObject):Boolean{
			return justCollided[obj];
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
			myGrids.length = 0;
		}
		
		public function get myCollisionGridTiles():Vector.<GridTile>{
			return this.myGrids;
		}

		public override function finishGameLoop():void{
			super.finishGameLoop();
			justCollided = new Dictionary(true);
			hit_box_prev = hitbox.clone();
		}
	}
}
