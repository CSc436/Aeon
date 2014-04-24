package org.interguild.game.tiles {

	import flash.display.Bitmap;

	import org.interguild.Aeon;


	public class Arrow extends CollidableObject {
		private var direction:int;
		public var parentDestroyed:Boolean;

		public static const LEVEL_CODE_CHAR:String='a';

		public static const DESTRUCTIBILITY:int=0;
		public static const IS_SOLID:Boolean=true;
		public static const HAS_GRAVITY:Boolean=false;
		public static const KNOCKBACK_AMOUNT:int=0;
		public static const IS_BUOYANT:Boolean=true;

		public function Arrow(x:int, y:int, direction:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT, LEVEL_CODE_CHAR, DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			this.direction=direction;
			parentDestroyed=false;
			this.isActive=true;
			switch (direction) {
				case 1:
					addChild(new Bitmap(new LightningRightSprite()));
					break;
				case 2:
					addChild(new Bitmap(new LightningDownSprite()));
					break;
				case 3:
					addChild(new Bitmap(new LightningLeftSprite()));
					break;
				case 4:
					addChild(new Bitmap(new LightningUpSprite()));
					break;
			}
		}

		public override function onGameLoop():void {
			if (parentDestroyed) {
				switch (direction) {
					case 1: // The arrow shoots right
						newX+=6;
						break;
					case 2: // The arrow shoots down
						newY+=6;
						break;
					case 3: // The arrow shoots left
						newX-=6;
						break;
					case 4: // The arrow shoots up
						newY-=6;
						break;
				}
				updateHitBox();
			}
		}
	}
}
