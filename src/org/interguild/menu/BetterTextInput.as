package org.interguild.menu {
	import flash.text.TextFormat;
	
	import fl.controls.TextInput;

	public class BetterTextInput extends TextInput {

		private static const PADDING_TOP:uint = 2;
		private static const PADDING_LEFT:uint = 4;
		private static const PADDING_RIGHT:uint = 5;
		private static const STANDARD_HEIGHT:uint = 22;

		private static const BG_COLOR:uint = 0xFFFFFF;
		private static const CORNER_RADIUS:uint = 8;
		
		private static const TEXT_FONT:String = "Verdana";
		private static const TEXT_SIZE:Number = 12;
		private static const TEXT_COLOR:uint = 0x000000;

		public function BetterTextInput(numbersOnly:Boolean = false) {
			super();
			height = STANDARD_HEIGHT;
			
			initFormat();
			drawBG();
		}

		public override function set width(w:Number):void {
			super.width = w - PADDING_LEFT - PADDING_RIGHT;
			drawBG();
		}

		public override function set x(n:Number):void {
			super.x = n + PADDING_LEFT;
		}

		public override function set y(n:Number):void {
			super.y = n + PADDING_TOP;
		}
		
		private function initFormat():void{
			var format:TextFormat = new TextFormat(TEXT_FONT, TEXT_SIZE, TEXT_COLOR);
			this.setStyle("textFormat", format);
		}

		private function drawBG():void {
			graphics.clear();
			graphics.beginFill(BG_COLOR);
			graphics.drawRoundRect(-PADDING_LEFT, -PADDING_TOP, width + PADDING_LEFT + PADDING_RIGHT, height, CORNER_RADIUS, CORNER_RADIUS);
		}
	}
}
