package org.interguild.components {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class DropdownMenuItem extends Sprite {
		
		private static const DEFAULT_BG_HEIGHT:uint = 25;
		private static const BG_WIDTH:uint = 200;
		private static const BG_COLOR_OVER:uint = 0x115867; //teal
		
		private var clickArea:Sprite;
		private var rolloverBG:Sprite;
		
		public function DropdownMenuItem(onClick:Function) {
			//init rollover bg
			rolloverBG = new Sprite();
			rolloverBG.graphics.beginFill(BG_COLOR_OVER);
			rolloverBG.graphics.drawRect(0, 0, BG_WIDTH, bgHeight);
			rolloverBG.graphics.endFill();
			rolloverBG.visible = false;
			addChild(rolloverBG);
			
			//init clickable area
			clickArea = new Sprite();
			clickArea.graphics.beginFill(0, 0);
			clickArea.graphics.drawRect(0, 0, BG_WIDTH, bgHeight);
			clickArea.graphics.endFill();
			clickArea.buttonMode = true;
			addChild(clickArea);
			
			//init events
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.CLICK, onClick, true);
		}
		
		protected function get bgHeight():uint{
			return DEFAULT_BG_HEIGHT;
		}
		
		protected function onMouseOver(evt:MouseEvent):void{
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			rolloverBG.visible = true;
		}
		
		protected function onMouseOut(evt:MouseEvent):void{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			rolloverBG.visible = false;
		}
	}
}
