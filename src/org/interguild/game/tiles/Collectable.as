package org.interguild.game.tiles {
	
	import flash.display.Bitmap;
	
	import org.interguild.Aeon;
	
	public class Collectable extends CollidableObject implements Tile {
		
		public static const LEVEL_CODE_CHAR:String = 'c';
		
		private static const SPRITE_COLOR:uint = 0xFFDA00;
		private static const SPRITE_WIDTH:uint = 32;
		private static const SPRITE_HEIGHT:uint = 32;
		private static const TILE_ENCODING:String = 'c';
		
		public var destructibility:int = 0;
		public var solidity:Boolean = true;
		public var gravible:Boolean = true;
		public var knocksback:int = 0;
		public var buoyancy:Boolean = false;
		
		public function Collectable(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			graphics.beginFill(SPRITE_COLOR);
			graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
			graphics.endFill();
			
			// Wood crate image is not working for some reason, even though steel crate is
			/*
			addChild(new Bitmap(new WoodenCrateSprite()));
			var a:BitmapData = new WoodenCrateSprite();
			var b:BitmapData = new SteelCrateSprite();
			trace("wood crate height is: " + a.height);
			trace("steel crate height is " + b.height);
			*/
			
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
		
		public override function onGameLoop():void{
			
			
			//commit location change:
			x = newX;
			y = newY;
			updateHitBox();
		}
	}
}
import org.interguild.game.tiles;

