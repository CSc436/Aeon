package org.interguild.game.tiles {
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.interguild.game.Player;
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
		private var sideBlocked:Array;
		private var active:Boolean;

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
			sideBlocked = [false, false, false, false];
			active = false;
		}

		/**
		 * Remembers which GridTiles the GameObject is
		 * currently in.
		 */
		public function addGridTile(g:GridTile):void {
			myGrids.push(g);
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
		
		protected function updateHitBox():void{
			hit_box.x = newX;
			hit_box.y = newY;
		}

		/**
		 * It's dangerous to do collision detection alone.
		 * Take this. 
		 */
		public function get hitbox():Rectangle {
			return hit_box;
		}
		
		/**
		 * Return what the hitbox used to be during the last frame.
		 */
		public function get hitboxPrev():Rectangle{
			return hit_box_prev;
		}
		
		/**
		 * Don't want to check collisions on the same object twice.
		 */
		public function setCollidedWith(obj:CollidableObject):void{
			justCollided[obj] = true;
		}
		
		public function hasCollidedWith(obj:CollidableObject):Boolean{
			return justCollided[obj];
		}
		
		/**
		 * Use the Direction class in the collision package for the parameter.
		 * Basically, if a tile goes to rest next to this one, tell this one
		 * about it so that we don't test for collisions on that side of the tile.
		 */
		public function setBlocked(direction:uint):void{
			sideBlocked[direction] = true;
		}
		
		public function setUnblocked(direction:uint):void{
			sideBlocked[direction] = false;
		}
		
		public function isBlocked(direction:uint):Boolean{
			return sideBlocked[direction];
		}
		
		public function set isActive(b:Boolean):void{
			//if changing state, reset blocked sides
			if(b != active)
				sideBlocked = [false, false, false, false];
			active = b;
		}
		
		public function get isActive():Boolean{
			return active;
		}
		
		public function removeSelf():void{
			for (var i:int = 0; i < myGrids.length; i++) {
				GridTile(myGrids[i]).removeObject(this);
			}
		}

		public override function finishGameLoop():void{
			super.finishGameLoop();
			justCollided = new Dictionary(true);
			updateHitBox();
			if(this is Player){
				trace("I am player");
			}
			hit_box_prev = hitbox.clone();
		}
	}
}
