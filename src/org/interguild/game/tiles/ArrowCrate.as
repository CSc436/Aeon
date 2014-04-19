package org.interguild.game.tiles
{
	import flash.display.Bitmap;
	
	import org.interguild.Aeon;
	import org.interguild.game.level.Level;
	
	public class ArrowCrate extends CollidableObject implements Tile {
		public static const LEVEL_CODE_CHAR_RIGHT:String = '>';
		public static const LEVEL_CODE_CHAR_DOWN:String = 'v';
		public static const LEVEL_CODE_CHAR_LEFT:String = '<'
		public static const LEVEL_CODE_CHAR_UP:String = '^'

		private static const GRAVITY:uint = 4;
		private static const MAX_FALL_SPEED:Number = 6;
		
		private static const SPRITE_COLOR:uint = 0xFF6600;
		private static const SPRITE_WIDTH:uint = 32;
		private static const SPRITE_HEIGHT:uint = 32;
		private static const TILE_ENCODING:String = 'a';
		
		// Arrow stuff
		public var arrow:Arrow;
		public var direction:int;
		public var xPos:int;
		public var yPos:int;
		
		public var destructibility:int = 2;
		public var solidity:Boolean = true;
		public var gravible:Boolean = false;
		public var knocksback:int = 5;
		public var buoyancy:Boolean = true;
		
		public function ArrowCrate(x:int, y:int, direction:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			this.xPos = x;
			this.yPos = y;
			this.direction = direction;
			addChild(new Bitmap(new WoodenCrateSprite()));
			switch (direction) {
				case 1:
					addChild(new Bitmap(new LightningRightSprite()));
					break;
				case 2:
					addChild(new Bitmap(new LightningBlockDownSprite()));
					break;
				case 3:
					addChild(new Bitmap(new LightningBlockLeftSprite()));
					break;
				case 4:
					addChild(new Bitmap(new LightningBlockUpSprite()));
					break;
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