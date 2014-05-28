package org.interguild.components {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class DropdownMenuItem extends Sprite {

		private static const DEFAULT_BG_HEIGHT:uint = 25;
		private static const DEFAULT_BG_WIDTH:uint = 200;
		private static const BG_COLOR_OVER:uint = 0x115867; //teal

		private var rolloverBG:Sprite;

		public function DropdownMenuItem(onClick:Function) {
			//init rollover bg
			rolloverBG = new Sprite();
			rolloverBG.graphics.beginFill(BG_COLOR_OVER);
			rolloverBG.graphics.drawRect(0, 0, bgWidth, bgHeight);
			rolloverBG.graphics.endFill();
			rolloverBG.visible = false;
			addChild(rolloverBG);

			//init clickable area
			var clickArea:Sprite = new Sprite();
			clickArea.graphics.beginFill(0, 0);
			clickArea.graphics.drawRect(0, 0, bgWidth, bgHeight);
			clickArea.graphics.endFill();
			addChild(clickArea);

			//init events
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, onClick);
			mouseChildren = false;
			buttonMode = true;
		}

		protected function get bgWidth():uint {
			return DEFAULT_BG_WIDTH;
		}

		protected function get bgHeight():uint {
			return DEFAULT_BG_HEIGHT;
		}

		protected function onMouseOver(evt:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			rolloverBG.visible = true;
		}

		protected function onMouseOut(evt:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			rolloverBG.visible = false;
		}
	}
}
