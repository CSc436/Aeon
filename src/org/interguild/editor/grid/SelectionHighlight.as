package org.interguild.editor.grid {
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * Responsible for controlling how the highlight
	 * for the Selection Tool.
	 */
	public class SelectionHighlight extends Sprite {

		private static const BG_COLOR:uint = 0x1fa6eb;
		private static const BG_ALPHA:Number = 0.5;
		private static const BORDER_COLOR:uint = 0x00d2ff;
		private static const BORDER_WIDTH:uint = 2;

		public function SelectionHighlight() {
			this.mouseEnabled = false;
		}

		public function resize(rect:Rectangle):void {
			graphics.clear();
			graphics.lineStyle(BORDER_WIDTH, BORDER_COLOR);
			graphics.beginFill(BG_COLOR, BG_ALPHA);
			graphics.drawRect(rect.x - 1, rect.y - 1, rect.width + 1, rect.height + 1);
			graphics.endFill();
		}
	}
}
