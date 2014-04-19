package org.interguild.game.tiles
{
	import com.greensock.motionPaths.Direction;
	
	import org.interguild.game.Player;
	
	public class Arrow extends CollidableObject implements Tile
	{
		private var direction:int;
		public var parentDestroyed:Boolean;
		
		public var destructibility:int = 0;
		public var solidity:Boolean = true;
		public var gravible:Boolean = false;
		public var knocksback:int = 0;
		public var buoyancy:Boolean = true;
		
		public function Arrow(x:int, y:int, direction:int)
		{
			super(x, y+4, 1, 1);
			this.direction = direction;
			parentDestroyed = false;
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(8, 8, 20, 10);
			graphics.endFill();
			this.isActive = true;
		}
		
		public override function onGameLoop():void {
			if(parentDestroyed) {
				switch (direction) {
					case 1: // The arrow shoots right
						newX += 6;
						break;
					case 2: // The arrow shoots down
						newY += 6;
						break;
					case 3: // The arrow shoots left
						newX -= 6;
						break;
					case 4: // The arrow shoots up
						newY -= 6;
						break;
				}
				updateHitBox();
			}
		}
		
		public function getDestructibility():int {
			return destructibility;
		}
		
		
		public function isSolid():Boolean {
			return solidity;
		}
		
		
		public function isGravible():Boolean {
			return gravible;
		}
		
		
		public function doesKnockback():int {
			return knocksback;
		}
		
		
		public function isBuoyant():Boolean {
			return buoyancy;
		}
	}
}