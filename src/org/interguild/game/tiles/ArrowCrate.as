package org.interguild.game.tiles
{
	import flash.display.Bitmap;
	
	import org.interguild.Aeon;
	import org.interguild.game.level.Level;
	
	public class ArrowCrate extends CollidableObject {
		public static const LEVEL_CODE_CHAR_RIGHT:String = '>';
		public static const LEVEL_CODE_CHAR_DOWN:String = 'v';
		public static const LEVEL_CODE_CHAR_LEFT:String = '<'
		public static const LEVEL_CODE_CHAR_UP:String = '^'

		private static const GRAVITY:uint = 4;
		private static const MAX_FALL_SPEED:Number = 6;
		
		// Arrow stuff
		public var arrow:Arrow;
		public var direction:int;
		public var xPos:int;
		public var yPos:int;
		public static const DESTRUCTIBILITY:int=2;
		public static const IS_SOLID:Boolean=true;
		public static const HAS_GRAVITY:Boolean=true;
		public static const KNOCKBACK_AMOUNT:int=5;
		public static const IS_BUOYANT:Boolean=true;
		public var LEVEL_CODE_CHAR:String;

		public function ArrowCrate(x:int, y:int, direction:int) {
			this.direction = direction;
			switch (direction) {
				case 1:
					addChild(new Bitmap(new LightningBoxRight()));
					LEVEL_CODE_CHAR = LEVEL_CODE_CHAR_RIGHT;
					break;
				case 2:
					addChild(new Bitmap(new LightningBoxDown()));
					LEVEL_CODE_CHAR = LEVEL_CODE_CHAR_DOWN;
					break;
				case 3:
					addChild(new Bitmap(new LightningBoxLeft()));
					LEVEL_CODE_CHAR = LEVEL_CODE_CHAR_LEFT;
					break;
				case 4:
					addChild(new Bitmap(new LightningBoxUp()));
					LEVEL_CODE_CHAR = LEVEL_CODE_CHAR_UP;
					break;
			}
			
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT, LEVEL_CODE_CHAR, DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			this.xPos=x;
			this.yPos=y;
		}
		
		public override function onGameLoop():void {
			//gravity
			speedY += GRAVITY;
			
			//update movement
			newX += speedX;
			newY += speedY;
			
			if (speedY > MAX_FALL_SPEED) {
				speedY = MAX_FALL_SPEED;
			}
			
			//commit location change:
			x = newX;
			y = newY;
			updateHitBox();
		}
		
		public override function onKillEvent(level:Level): void {
			arrow = new Arrow(newX, newY, direction);
			level.createCollidableObject(arrow);
			this.arrow.parentDestroyed = true;
		}
	}
}