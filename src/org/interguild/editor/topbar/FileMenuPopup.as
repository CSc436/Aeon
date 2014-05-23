package org.interguild.editor.topbar {
	import flash.display.Sprite;

	public class FileMenuPopup extends Sprite {

		private static const BG_COLOR:uint = 0xcecece;
		private static const BG_CORNER_RADIUS:uint = 15;

		private static const PADDING_X:uint = 5;
		private static const PADDING_Y:uint = 5;
		private static const SPACING:uint = 0;

		private var bg:Sprite;

		private var nextY:uint;

		public function FileMenuPopup() {
			//init bg
			bg = new Sprite();
			addChild(bg);

			nextY = PADDING_Y;
		}

		public function addItem(i:FileMenuItem):void {
			i.x = PADDING_X;
			i.y = nextY;
			addChild(i);

			nextY += i.height + SPACING;
			redraw();
		}

		private function redraw():void {
			bg.graphics.clear();
			bg.graphics.beginFill(BG_COLOR);
			bg.graphics.drawRoundRect(0, 0, width + (PADDING_X * 2), height + (PADDING_Y * 2), BG_CORNER_RADIUS, BG_CORNER_RADIUS);
			bg.graphics.endFill();
		}
	}
}
