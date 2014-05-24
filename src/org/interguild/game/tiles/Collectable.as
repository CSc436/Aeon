package org.interguild.game.tiles {

	import flash.display.Bitmap;

	import org.interguild.Aeon;
	import flash.display.BitmapData;

	public class Collectable extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'c';
		public static const EDITOR_ICON:BitmapData = new CollectibleSprite();

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;

		public function Collectable(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);
			
			addChild(new Bitmap(new CollectibleSprite()));
		}
	}
}
