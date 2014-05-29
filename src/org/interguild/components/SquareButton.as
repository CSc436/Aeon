package org.interguild.components {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SquareButton extends FancyButton {

		private static const BUTTON_FONT_FAMILY:String = "Verdana";
		private static const BUTTON_FONT_COLOR:uint = 0xf1f1f1;
		private static const BUTTON_SIZE:uint = 14;

		public function SquareButton(label:String, upColor:uint, overColor:uint, borderColor:uint, width:Number, height:Number) {
			var upState:Sprite = new Sprite();
			drawButtonBorder(upState, width, height, borderColor);
			drawButtonBG(upState, width, height, upColor);

			var overState:Sprite = new Sprite();
			drawButtonBorder(overState, width, height, borderColor);
			drawButtonBG(overState, width, height, overColor);

			var hitState:Sprite = new Sprite();
			drawButtonBorder(hitState, width, height, 0, 0);
			drawButtonBG(hitState, width, height, 0, 0);

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

		private function drawButtonBorder(button:Sprite, width:Number, height:Number, color:uint, alpha:Number = 1):void {
			button.graphics.beginFill(color, alpha);
			button.graphics.drawRect(0, 0, width + 2, height + 2);
			button.graphics.endFill();
		}

		private function drawButtonBG(button:Sprite, width:Number, height:Number, color:uint, alpha:Number = 1):void {
			button.graphics.beginFill(color, alpha);
			button.graphics.drawRect(1, 1, width, height);
			button.graphics.endFill();
		}
	}
}
