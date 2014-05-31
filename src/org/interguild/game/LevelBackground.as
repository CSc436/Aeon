package org.interguild.game {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import org.interguild.Aeon;

	public class LevelBackground extends Sprite {

		private static var BG_MAP:Array;
		private static var BG_BITMAP:uint = 0;
		private static var BG_THUMBNAIL:uint = 1;
		private static var BG_NAME:uint = 2;

		private static function initMap():void {
			BG_MAP = [];
			BG_MAP.push([new BackgroundTeal(), new BackgroundTealMini(), "Teal"]);
			BG_MAP.push([new BackgroundGreen(), new BackgroundGreenMini(), "Green"]);
			BG_MAP.push([new BackgroundPurple(), new BackgroundPurpleMini(), "Purple"]);
		}

		private static function isInBounds(id:Number):Boolean {
			if (BG_MAP == null)
				initMap();

			if (isNaN(id) || id < 0 || id >= BG_MAP.length)
				return false;
			else
				return true;
		}

		public static function getBackground(id:Number):BitmapData {
			if (!isInBounds(id))
				return null;

			return BG_MAP[id][BG_BITMAP];
		}

		public static function getThumbnail(id:Number):BitmapData {
			if (!isInBounds(id))
				return null;

			return BG_MAP[id][BG_THUMBNAIL];
		}

		public static function getName(id:Number):String {
			if (!isInBounds(id))
				return null;

			return BG_MAP[id][BG_NAME];
		}

		private var bg:Sprite;

		public function LevelBackground(w:Number, h:Number, bgID:uint) {
			bg = new Sprite();
			var bmd:BitmapData = getBackground(bgID);
			bg.graphics.beginBitmapFill(bmd);
//			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0, 0, w << 2, bmd.height);
			bg.graphics.endFill();
			bg.y = Aeon.STAGE_HEIGHT - bmd.height;
			addChild(bg);
		}
	}
}
