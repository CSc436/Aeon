package org.interguild.game.tiles {
	import org.interguild.Aeon;

	public class SecretArea extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'z';
		
		private static const IS_SOLID:Boolean = true;
		private static const NO_GRAVITY:Boolean = false;

		public function SecretArea(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, NO_GRAVITY);
			
			visible = false;
			
			TerrainView.getMe().drawTerrainAt(x, y, true);
		}
	}
}
