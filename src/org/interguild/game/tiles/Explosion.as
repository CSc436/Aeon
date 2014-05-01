package org.interguild.game.tiles
{
	import org.interguild.Aeon;

	public class Explosion extends CollidableObject
	{
		private var direction:int;
		public var parentDestroyed:Boolean;
		
		public static const LEVEL_CODE_CHAR:String='e';
		
		public static const DESTRUCTIBILITY:int=0;
		public static const IS_SOLID:Boolean=false;
		public static const HAS_GRAVITY:Boolean=false;
		public static const KNOCKBACK_AMOUNT:int=0;
		public static const IS_BUOYANT:Boolean=true;
		
		public var timeCounter:int = 0;
		
		public function Explosion(x:int, y:int)
		{
			super((x-16), (y-16), 64, 64, LEVEL_CODE_CHAR, DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			parentDestroyed = false;
			this.isActive = true;
			
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, 64, 64);
			graphics.endFill();
		}
		
		public override function onGameLoop():void {
			if (parentDestroyed) {
				timeCounter++;
			}
		}
	}
}