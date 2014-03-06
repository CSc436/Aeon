package org.interguild.game {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.CollidableObject;

	public class Player extends CollidableObject {

		private static const HITBOX_WIDTH:uint = 24;
		private static const HITBOX_HEIGHT:uint = 40;

		private static const SPRITE_COLOR:uint = 0xFF0000;
		private static const SPRITE_WIDTH:uint = 24;
		private static const SPRITE_HEIGHT:uint = 40;

		private static const MAX_FALL_SPEED:Number = 7;
		private static const MAX_RUN_SPEED:Number = 3;

		private static const RUN_ACC:Number = MAX_RUN_SPEED;
		private static const RUN_FRICTION:Number = 2;

		private static const JUMP_SPEED:Number = -28;

		private var maxSpeedY:Number = MAX_FALL_SPEED;
		private var maxSpeedX:Number = MAX_RUN_SPEED;

		private var keys:KeyMan;
		public var isStanding:Boolean;
		
		[Embed(source = "../../../../images/WalkJumpTransparentSprite.png")]
		private var Sprite_Sheet:Class;
		
		private var spriteRunRightArray:Array;
		private var spriteJumpArray:Array;
		private var currSprite:Bitmap;
		private var currIndex:int = 1;
	
		public function Player() {
			super(0, 0, HITBOX_WIDTH, HITBOX_HEIGHT);
			drawPlayer();
			isActive = true;
			keys = KeyMan.getMe();
		}

		public function setStartPosition(sx:Number, sy:Number):void {
			x = newX = startX = sx;
			y = newY = startY = sy;
		}

		private function drawPlayer():void {
			var dogBm:Bitmap = new Sprite_Sheet();			
			var dogBmd:BitmapData = dogBm.bitmapData;
	
			var dogRect:Rectangle = new Rectangle(0, 0, 36, 49);
			var dogData:BitmapData = new BitmapData(36, 49);
			dogData.copyPixels(dogBmd, dogRect, new Point());
			var dogBitMap:Bitmap = new Bitmap(dogData);
		
			dogBitMap.x = -2;
			dogBitMap.y = -8;
			currSprite = dogBitMap;
			addChild(currSprite);

			graphics.beginFill(SPRITE_COLOR);
			graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
			graphics.endFill();
			
			spriteRunRightArray = new Array();
			//populate running sprite array
			for(var a:int = 0; a < 10; a++) {
				var rect:Rectangle = new Rectangle(a*36, 0, 36, 49);
				var data:BitmapData = new BitmapData(36, 49);
				data.copyPixels(dogBmd, rect, new Point());
				var bm:Bitmap = new Bitmap(data);
				bm.x = -2;
				bm.y = -8;
				spriteRunRightArray.push(bm);
			}
			
			spriteJumpArray = new Array();
			//populate jumping sprite array
			for(a = 0; a < 7; a++) {
				rect = new Rectangle(a*36, 50, 36, 49);
				data = new BitmapData(36, 49);
				data.copyPixels(dogBmd, rect, new Point());
				bm = new Bitmap(data);
				bm.x = -2;
				bm.y = -8;
				spriteJumpArray.push(bm);
			}
			
		}

		public override function onGameLoop():void {
			trace("The vertical speed is: " + speedY);
			trace("The horizontal speed is: " + speedX);
			
			if(isStanding) {
				removeChild(currSprite);
				currSprite = spriteJumpArray[0];
				addChild(currSprite);
			}
			
			// -28, -24, -20, -16, -12, -8, -4, 0, 4, 7 are all the possible vertical speeds
			switch(speedY) {
				case -28:
				case -24:
					removeChild(currSprite);
					currSprite = spriteJumpArray[1];
					addChild(currSprite);
					break;
				case -20:
				case -16:
					removeChild(currSprite);
					currSprite = spriteJumpArray[2];
					addChild(currSprite);
					break;
				case -12:
				case -8:
					removeChild(currSprite);
					currSprite = spriteJumpArray[3];
					addChild(currSprite);
					break;
				case -4:
					removeChild(currSprite);
					currSprite = spriteJumpArray[4];
					addChild(currSprite);
					break;
				case 4:
				case 7:
					removeChild(currSprite);
					currSprite = spriteJumpArray[5];
					addChild(currSprite);
					break;
				case 0:
					if(!isStanding) {
						removeChild(currSprite);
						currSprite = spriteJumpArray[0];
						addChild(currSprite);
					}
					break;
				default:
					break;
			}
			
			//gravity
			speedY += Level.GRAVITY;

			updateKeys();

			// reset isStanding
			reset();

			//update movement
			newX += speedX;
			newY += speedY;

			if (speedY > MAX_FALL_SPEED) {
				speedY = MAX_FALL_SPEED;
			}
			if (speedX > MAX_RUN_SPEED) {
				speedX = MAX_RUN_SPEED;
			} else if (speedX < -MAX_RUN_SPEED) {
				speedX = -MAX_RUN_SPEED;
			}

			//commit location change:
			x = newX;
			y = newY;
		}

		private function reset():void {
			isStanding = false;
		}

		private function updateKeys():void {
			//moving to the left
			if (keys.isKeyLeft) {
				speedX -= RUN_ACC;
			} else if (speedX < 0) {
				speedX += RUN_FRICTION;
				if (speedX > 0)
					speedX = 0;
			}
			//moving to the right
			if (keys.isKeyRight) {
				speedX += RUN_ACC;
			//	if(speedY == 0) {
					removeChild(currSprite);
					currSprite = spriteRunRightArray[currIndex];
					addChild(currSprite);
					currIndex++;
					if(currIndex >= spriteRunRightArray.length)
						currIndex = 0;
				//}
			} else if (speedX > 0) {
				speedX -= RUN_FRICTION;
				if (speedX < 0)
					speedX = 0;
			}

			//jump
			if (keys.isKeySpace && isStanding) {
				speedY = JUMP_SPEED;
			}
		}
	}
}
