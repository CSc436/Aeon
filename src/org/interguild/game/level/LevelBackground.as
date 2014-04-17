package org.interguild.game.level {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import org.interguild.Aeon;

	public class LevelBackground extends Sprite {
		
		private var bg:Sprite;
		
		public function LevelBackground(w:Number, h:Number) {
			bg = new Sprite();
			var bmd:BitmapData = new BackgroundTeal();
			bg.graphics.beginBitmapFill(bmd);
//			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0, 0, w << 2, bmd.height);
			bg.graphics.endFill();
			bg.y = Aeon.STAGE_HEIGHT - bmd.height;
			addChild(bg);
		}
	}
}
