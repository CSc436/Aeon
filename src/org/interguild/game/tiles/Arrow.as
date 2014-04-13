package org.interguild.game.tiles
{
	import com.greensock.motionPaths.Direction;
	
	import org.interguild.game.Player;
	
	public class Arrow extends CollidableObject
	{
		private var direction:int;
		public var parentDestroyed:Boolean;
		
		public function Arrow(x:int, y:int, direction:int)
		{
			super(x, y, 5, 16);
			this.direction = direction;
			parentDestroyed = false;
			graphics.beginFill(0x000000);
			graphics.drawRect(8, 8, 20, 10);
			graphics.endFill();
			this.isActive = true;
		}
		
		public override function onGameLoop():void {
			if(parentDestroyed) {
				newX += 3;
				updateHitBox();
			}
		}
	}
}