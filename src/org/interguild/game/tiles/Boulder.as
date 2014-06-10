package org.interguild.game.tiles {
	import flash.display.BitmapData;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.game.collision.Destruction;

	public class Boulder extends CollidableObject {
		
		public static const LEVEL_CODE_CHAR:String = 'o';
		public static const EDITOR_ICON:BitmapData = Assets.BOULDER;
		
		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;
		
		public function Boulder(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);
			destruction.destroyedBy(Destruction.ARROWS);
			destruction.destroyedBy(Destruction.EXPLOSIONS);
			destruction.destroyWithMarker(Destruction.BOULDERS);
			
			setFaces(Assets.BOULDER);
		}
	}
}
