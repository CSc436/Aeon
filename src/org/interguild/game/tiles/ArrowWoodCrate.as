package org.interguild.game.tiles {
	import flash.display.BitmapData;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.SoundMan;
	import org.interguild.game.Level;
	import org.interguild.game.collision.Direction;

	public class ArrowWoodCrate extends CollidableObject {

		public static const LEVEL_CODE_CHAR_RIGHT:String = '>';
		public static const LEVEL_CODE_CHAR_DOWN:String = 'v';
		public static const LEVEL_CODE_CHAR_LEFT:String = '<';
		public static const LEVEL_CODE_CHAR_UP:String = '^';

		public static const EDITOR_ICON_RIGHT:BitmapData = Assets.ARROW_CRATE_RIGHT;
		public static const EDITOR_ICON_LEFT:BitmapData = Assets.ARROW_CRATE_LEFT;
		public static const EDITOR_ICON_UP:BitmapData = Assets.ARROW_CRATE_UP;
		public static const EDITOR_ICON_DOWN:BitmapData = Assets.ARROW_CRATE_DOWN;

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = false;
		private static const KNOCKBACK_AMOUNT:int = 5;

		public var arrow:Arrow;
		public var direction:int;
		public var xPos:int;
		public var yPos:int;

		private var sounds:SoundMan;

		public function ArrowWoodCrate(x:int, y:int, direction:int, arrow:Arrow) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			CollidableObject.setWoodenCrateDestruction(this);

			this.sounds = SoundMan.getMe();
			this.arrow = arrow;
			this.direction = direction;
			switch (direction) {
				case Direction.RIGHT:
					setFaces(Assets.ARROW_CRATE_RIGHT);
					break;
				case Direction.DOWN:
					setFaces(Assets.ARROW_CRATE_DOWN);
					break;
				case Direction.LEFT:
					setFaces(Assets.ARROW_CRATE_LEFT);
					break;
				case Direction.UP:
					setFaces(Assets.ARROW_CRATE_UP);
					break;
			}

			this.xPos = x;
			this.yPos = y;
		}

		public override function onKillEvent(level:Level):Array {
			arrow.moveTo(xPos, yPos);
			sounds.playSound(SoundMan.ARROW_FIRING_SOUND);
			return [arrow];
		}
	}
}
