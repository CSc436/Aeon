package org.interguild.game.tiles {

	import flash.display.Bitmap;

	import org.interguild.Aeon;
	import flash.display.BitmapData;

	public class SteelCrate extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 's';
		public static const EDITOR_ICON:BitmapData = new SteelCrateSprite();

		private static const DESTRUCTIBILITY:int = 0;
		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;
		private static const KNOCKBACK_AMOUNT:int = 0;
		private static const IS_BUOYANT:Boolean = false;

		public function SteelCrate(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT, IS_BUOYANT);
			addChild(new Bitmap(new SteelCrateSprite()));
		}
	}
}
