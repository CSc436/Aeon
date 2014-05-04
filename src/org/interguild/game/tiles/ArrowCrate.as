package org.interguild.game.tiles
{
	import flash.display.Bitmap;
	
	import org.interguild.Aeon;
	import org.interguild.game.collision.Direction;
	import org.interguild.game.level.Level;
	
	//TODO Henry wants to add subclasses for each directional arrow for the editor page
	public class ArrowCrate extends CollidableObject {
		public static const LEVEL_CODE_CHAR_RIGHT:String = '>';
		public static const LEVEL_CODE_CHAR_DOWN:String = 'v';
		public static const LEVEL_CODE_CHAR_LEFT:String = '<'
		public static const LEVEL_CODE_CHAR_UP:String = '^'

		private static const GRAVITY:uint = 4;
		private static const MAX_FALL_SPEED:Number = 6;
		
//		private static const SPRITE_COLOR:uint = 0xFF6600;
//		private static const SPRITE_WIDTH:uint = 32;
//		private static const SPRITE_HEIGHT:uint = 32;
//		private static const TILE_ENCODING:String = 'a';
		
		// Arrow stuff
		public var arrow:Arrow;
		public var direction:int;
		public var xPos:int;
		public var yPos:int;
		public static const DESTRUCTIBILITY:int=2;
		public static const IS_SOLID:Boolean=true;
		public static const HAS_GRAVITY:Boolean=false;
		public static const KNOCKBACK_AMOUNT:int=5;
		public static const IS_BUOYANT:Boolean=true;
		public var LEVEL_CODE_CHAR:String;
		public static var LEVEL_CODE_CHAR:Object;

		public function ArrowCrate(x:int, y:int, direction:int) {
			this.direction = direction;
			switch (direction) {
				case Direction.RIGHT:
					addChild(new Bitmap(new LightningBoxRight()));
					LEVEL_CODE_CHAR = LEVEL_CODE_CHAR_RIGHT;
					break;
				case Direction.DOWN:
					addChild(new Bitmap(new LightningBoxDown()));
					LEVEL_CODE_CHAR = LEVEL_CODE_CHAR_DOWN;
					break;
				case Direction.LEFT:
					addChild(new Bitmap(new LightningBoxLeft()));
					LEVEL_CODE_CHAR = LEVEL_CODE_CHAR_LEFT;
					break;
				case Direction.UP:
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
			arrow = new Arrow(xPos, yPos, direction);
			level.createCollidableObject(arrow);
			this.arrow.parentDestroyed = true;
		}
	}
}