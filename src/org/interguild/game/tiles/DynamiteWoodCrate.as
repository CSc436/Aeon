package org.interguild.game.tiles {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.SoundMan;
	import org.interguild.game.Level;
	import org.interguild.game.collision.Direction;

	public class DynamiteWoodCrate extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'd';
		public static const EDITOR_ICON:BitmapData = Assets.DYNAMITE_WOOD_CRATE;

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;
		private static const KNOCKBACK_AMOUNT:int = 5;
		
		private static const DISTANCE_FROM_CENTER:uint = 12;

		private var sounds:SoundMan;
		private var stick:DynamiteStick;
		private var explosion:Explosion;
		private var playerKilled:Boolean;
		private var playerDirection:uint;

		public function DynamiteWoodCrate(x:int, y:int, stick:DynamiteStick, explosion:Explosion) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			CollidableObject.setWoodenCrateDestruction(this);

			setFaces(Assets.DYNAMITE_WOOD_CRATE);
			sounds = SoundMan.getMe();
			this.explosion = explosion;
			this.stick = stick;
		}
		
		public function killedByPlayer(direction:uint, playerPos:Rectangle):void{
			playerKilled = true;
			playerDirection = direction;
			if(playerDirection == Direction.DOWN){
				var playerMiddle:Number = playerPos.left + (playerPos.width / 2);
				var myBox:Rectangle = hitbox;
				var myMiddle:Number = myBox.x + (myBox.width / 2);
				if(playerMiddle <= myMiddle - DISTANCE_FROM_CENTER)
					playerDirection = Direction.RIGHT;
				else if(playerMiddle >= myMiddle + DISTANCE_FROM_CENTER)
					playerDirection = Direction.LEFT;
			}
		}

		public override function onKillEvent(level:Level):Array {
			if (playerKilled) {
				stick.playerDirection = playerDirection;
				stick.moveTo(newX, newY);
//				sounds.playSound(SoundMan.EXPLOSION_SOUND);
				return [stick];
			} else {
				explosion.moveTo(newX, newY);
				sounds.playSound(SoundMan.EXPLOSION_SOUND);
				return [explosion];
			}
		}
	}
}
