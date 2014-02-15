package org.interguild.game.tiles {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.interguild.game.collision.GridTile;

	public class CollidableObject extends Sprite {

		private var myGrids:Vector.<GridTile>;
		private var hitbox:Rectangle;

		public function CollidableObject(width:Number, height:Number) {
			myGrids = new Vector.<GridTile>();
			hitbox = new Rectangle(0, 0, width, height);
		}

		public function addGridTile(g:GridTile):void {
			myGrids.push(g);
		}
	}
}
