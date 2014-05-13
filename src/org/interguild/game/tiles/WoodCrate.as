package org.interguild.game.tiles {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import org.interguild.Aeon;

	public class WoodCrate extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'w';
		public static const EDITOR_ICON:BitmapData = new WoodenCrateSprite();

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;
		private static const KNOCKBACK_AMOUNT:int = 5;

		public function WoodCrate(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			CollidableObject.setWoodenCrateDestruction(this);
			
			addChild(new Bitmap(new WoodenCrateSprite()));
		}
	}
}

