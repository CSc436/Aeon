package org.interguild.game.tiles {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.net.URLRequest;

	import org.interguild.Aeon;
	import org.interguild.INTERGUILD;
	import org.interguild.game.collision.Direction;
	import org.interguild.game.Level;

	public class ArrowCrate extends CollidableObject {

		public static const LEVEL_CODE_CHAR_RIGHT:String = '>';
		public static const LEVEL_CODE_CHAR_DOWN:String = 'v';
		public static const LEVEL_CODE_CHAR_LEFT:String = '<';
		public static const LEVEL_CODE_CHAR_UP:String = '^';

		public static const EDITOR_ICON_RIGHT:BitmapData = new LightningBoxRight();
		public static const EDITOR_ICON_LEFT:BitmapData = new LightningBoxLeft();
		public static const EDITOR_ICON_UP:BitmapData = new LightningBoxUp();
		public static const EDITOR_ICON_DOWN:BitmapData = new LightningBoxDown();

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = false;
		private static const KNOCKBACK_AMOUNT:int = 5;

		public var arrow:Arrow;
		public var direction:int;
		public var xPos:int;
		public var yPos:int;

		public var arrowSound:Sound;

		public function ArrowCrate(x:int, y:int, direction:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			CollidableObject.setWoodenCrateDestruction(this);

			this.direction = direction;
			switch (direction) {
				case Direction.RIGHT:
					addChild(new Bitmap(new LightningBoxRight()));
					break;
				case Direction.DOWN:
					addChild(new Bitmap(new LightningBoxDown()));
					break;
				case Direction.LEFT:
					addChild(new Bitmap(new LightningBoxLeft()));
					break;
				case Direction.UP:
					addChild(new Bitmap(new LightningBoxUp()));
					break;
			}

			this.xPos = x;
			this.yPos = y;
			arrowSound = new Sound();
			CONFIG::ONLINE {
				arrowSound.load(new URLRequest(INTERGUILD.ORG + "/aeon_demo/Arrow.mp3"));
			}
			CONFIG::OFFLINE {
				arrowSound.load(new URLRequest("../assets/Arrow.mp3"));
			}
		}

		public override function onKillEvent(level:Level):void {
			arrow = new Arrow(xPos, yPos, direction);
			level.createCollidableObject(arrow);
			this.arrow.parentDestroyed = true;
			arrowSound.play();
		}
	}
}
