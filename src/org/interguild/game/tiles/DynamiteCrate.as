package org.interguild.game.tiles
{
	import flash.display.Bitmap;
	
	import org.interguild.Aeon;
	
	public class DynamiteCrate extends CollidableObject
	{
		public static const LEVEL_CODE_CHAR:String = 'd';
		public static const DESTRUCTIBILITY:int=2;
		public static const IS_SOLID:Boolean=true;
		public static const HAS_GRAVITY:Boolean=true;
		public static const KNOCKBACK_AMOUNT:int=5;
		public static const IS_BUOYANT:Boolean=true;
		
		public function DynamiteCrate(x:int, y:int)
		{
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT, LEVEL_CODE_CHAR, DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			addChild(new PlayerWalkingAnimation());
		}
	}
}