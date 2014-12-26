package org.interguild.game {
	import flash.display.BitmapData;
	import flash.display.Sprite;

	import org.interguild.Aeon;
	import org.interguild.Assets;

	public class LevelBackground extends Sprite {

		public function LevelBackground(w:Number, h:Number, bgID:uint) {
			var bg:Sprite = new Sprite();
			var bmd:BitmapData = Assets.getBGImge(bgID);
			bg.graphics.beginBitmapFill(bmd);
//			bg.graphics.beginFill(0xFFFFFF);
			var drawHeight:Number = bmd.height;
			if (drawHeight < 200) {
				drawHeight = Aeon.STAGE_HEIGHT;
			}
			bg.graphics.drawRect(0, 0, w << 2, drawHeight);
			bg.graphics.endFill();
			bg.y = Aeon.STAGE_HEIGHT - drawHeight;
			addChild(bg);
		}
	}
}
