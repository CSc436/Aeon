package org.interguild.components {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SquareButton extends FancyButton {

		private static const BUTTON_FONT_FAMILY:String = "Verdana";
		private static const BUTTON_FONT_COLOR:uint = 0xf1f1f1;
		private static const BUTTON_SIZE:uint = 14;
		private static const OPTIONAL_ROUNDING:uint = 20;

		public function SquareButton(label:String, upColor:uint, overColor:uint, borderColor:uint, width:Number, height:Number, rounded:Boolean = false) {
			var upState:Sprite = new Sprite();
			drawButtonBorder(upState, width, height, borderColor, 1, rounded);
			drawButtonBG(upState, width, height, upColor, 1, rounded);

			var overState:Sprite = new Sprite();
			drawButtonBorder(overState, width, height, borderColor, 1, rounded);
			drawButtonBG(overState, width, height, overColor, 1, rounded);

			var hitState:Sprite = new Sprite();
			drawButtonBorder(hitState, width, height, 0, 0, rounded);
			drawButtonBG(hitState, width, height, 0, 0, rounded);

			super(upState, overState, hitState);

			var text:TextField = new TextField();
			text.autoSize = TextFieldAutoSize.LEFT;
			text.defaultTextFormat = new TextFormat(BUTTON_FONT_FAMILY, BUTTON_SIZE, BUTTON_FONT_COLOR);
			text.selectable = false;
			text.mouseEnabled = false;
			text.text = label;
			text.x = width / 2 - text.width / 2;
			text.y = height / 2 - text.height / 2;
			addChild(text);
		}

		private function drawButtonBorder(button:Sprite, width:Number, height:Number, color:uint, alpha:Number = 1, rounded:Boolean = false):void {
			button.graphics.beginFill(color, alpha);
			if (rounded)
				button.graphics.drawRoundRect(0, 0, width + 2, height + 2, OPTIONAL_ROUNDING, OPTIONAL_ROUNDING);
			else
				button.graphics.drawRect(0, 0, width + 2, height + 2);
			button.graphics.endFill();
		}

		private function drawButtonBG(button:Sprite, width:Number, height:Number, color:uint, alpha:Number = 1, rounded:Boolean = false):void {
			button.graphics.beginFill(color, alpha);
			if (rounded)
				button.graphics.drawRoundRect(1, 1, width, height, OPTIONAL_ROUNDING, OPTIONAL_ROUNDING);
			else
				button.graphics.drawRect(1, 1, width, height);
			button.graphics.endFill();
		}
	}
}
