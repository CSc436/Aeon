package org.interguild.game.tiles {
	import flash.display.BitmapData;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.SoundMan;
	import org.interguild.game.Level;
	import org.interguild.game.collision.Direction;

	public class ArrowCrate extends CollidableObject {

		public static const LEVEL_CODE_CHAR_WOOD_RIGHT:String = '>';
		public static const LEVEL_CODE_CHAR_WOOD_DOWN:String = 'v';
		public static const LEVEL_CODE_CHAR_WOOD_LEFT:String = '<';
		public static const LEVEL_CODE_CHAR_WOOD_UP:String = '^';
		public static const LEVEL_CODE_CHAR_STEEL_RIGHT:String = ']';
		public static const LEVEL_CODE_CHAR_STEEL_DOWN:String = 'H';
		public static const LEVEL_CODE_CHAR_STEEL_LEFT:String = '[';
		public static const LEVEL_CODE_CHAR_STEEL_UP:String = 'T';

		public static const EDITOR_ICON_WOOD_RIGHT:BitmapData = Assets.ARROW_CRATE_WOOD_RIGHT;
		public static const EDITOR_ICON_WOOD_LEFT:BitmapData = Assets.ARROW_CRATE_WOOD_LEFT;
		public static const EDITOR_ICON_WOOD_UP:BitmapData = Assets.ARROW_CRATE_WOOD_UP;
		public static const EDITOR_ICON_WOOD_DOWN:BitmapData = Assets.ARROW_CRATE_WOOD_DOWN;
		public static const EDITOR_ICON_STEEL_RIGHT:BitmapData = Assets.ARROW_CRATE_STEEL_RIGHT;
		public static const EDITOR_ICON_STEEL_LEFT:BitmapData = Assets.ARROW_CRATE_STEEL_LEFT;
		public static const EDITOR_ICON_STEEL_UP:BitmapData = Assets.ARROW_CRATE_STEEL_UP;
		public static const EDITOR_ICON_STEEL_DOWN:BitmapData = Assets.ARROW_CRATE_STEEL_DOWN;

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = false;
		private static const KNOCKBACK_AMOUNT:int = 5;

		public var arrow:Arrow;
		public var direction:int;
		public var xPos:int;
		public var yPos:int;

		private var sounds:SoundMan;

		public function ArrowCrate(x:int, y:int, direction:int, arrow:Arrow, isSteel:Boolean = false) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			if(isSteel){
				setProperties(IS_SOLID, HAS_GRAVITY);
				CollidableObject.setSteelCrateDestruction(this);
				switch (direction) {
					case Direction.RIGHT:
						setFaces(Assets.ARROW_CRATE_STEEL_RIGHT);
						break;
					case Direction.DOWN:
						setFaces(Assets.ARROW_CRATE_STEEL_DOWN);
						break;
					case Direction.LEFT:
						setFaces(Assets.ARROW_CRATE_STEEL_LEFT);
						break;
					case Direction.UP:
						setFaces(Assets.ARROW_CRATE_STEEL_UP);
						break;
				}
			}else{
				setProperties(IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
				CollidableObject.setWoodenCrateDestruction(this);
				switch (direction) {
					case Direction.RIGHT:
						setFaces(Assets.ARROW_CRATE_WOOD_RIGHT);
						break;
					case Direction.DOWN:
						setFaces(Assets.ARROW_CRATE_WOOD_DOWN);
						break;
					case Direction.LEFT:
						setFaces(Assets.ARROW_CRATE_WOOD_LEFT);
						break;
					case Direction.UP:
						setFaces(Assets.ARROW_CRATE_WOOD_UP);
						break;
				}
			}

			this.sounds = SoundMan.getMe();
			this.arrow = arrow;
			this.direction = direction;
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
