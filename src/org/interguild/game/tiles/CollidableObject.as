package org.interguild.game.tiles {
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import org.interguild.game.collision.GridTile;

	public class CollidableObject extends Sprite {

		private var myGrids:Vector.<GridTile>;
		private var hit_box:Rectangle;

		public function CollidableObject(width:Number, height:Number) {
			myGrids = new Vector.<GridTile>();
			hit_box = new Rectangle(0, 0, width, height);
		}

		public function addGridTile(g:GridTile):void {
			myGrids.push(g);
		}

		public function get hitbox():Rectangle {
			hit_box.x = x;
			hit_box.y = y;
			return hit_box;
		}

		public function clearGrids():void {
			var len:uint = myGrids.length;
			for (var i:uint = 0; i < len; i++) {
				GridTile(myGrids[i]).removeObject(this);
			}
		}
	}
}
