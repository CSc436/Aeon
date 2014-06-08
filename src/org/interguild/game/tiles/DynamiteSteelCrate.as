package org.interguild.game.tiles {
	import flash.display.BitmapData;

	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.SoundMan;
	import org.interguild.game.Level;

	public class DynamiteSteelCrate extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'D';
		public static const EDITOR_ICON:BitmapData = Assets.DYNAMITE_WOOD_CRATE;

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;

		private var sounds:SoundMan;
		private var explosion:Explosion;

		public function DynamiteSteelCrate(x:int, y:int, explosion:Explosion) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);
			CollidableObject.setSteelCrateDestruction(this);

			setFaces(Assets.DYNAMITE_WOOD_CRATE);
			sounds = SoundMan.getMe();
			this.explosion = explosion;
		}

		public override function onKillEvent(level:Level):Array {
			explosion.moveTo(newX, newY);
			sounds.playSound(SoundMan.EXPLOSION_SOUND);
			return [explosion];
		}
	}
}
