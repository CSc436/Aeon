package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.interguild.Aeon;
	import org.interguild.menu.FancyButton;

	public class LevelPropertiesScreen extends Sprite {

		private static const WINDOW_X:uint = 21;
		private static const WINDOW_Y:uint = 15;
		private static const WINDOW_WIDTH:uint = 275;
		private static const WINDOW_HEIGHT:uint = 371;

		private static const BUTTON_WIDTH:Number = 78;
		private static const BUTTON_HEIGHT:Number = 37;
		private static const BUTTON_Y:Number = 325;

		private static const OKAY_BG_COLOR_UP:uint = 0x116e79;//0x008173;
		private static const OKAY_BG_COLOR_OVER:uint = 0x1498a8;//0x009b8b;
		private static const OKAY_BORDER_COLOR:uint = 0x48daff;
		private static const OKAY_TEXT_X:uint = 20;
		private static const OKAY_X:uint = 72;

		private static const CANCEL_BG_COLOR_UP:uint = 0x4b4b4b;
		private static const CANCEL_BG_COLOR_OVER:uint = 0x676767;
		private static const CANCEL_BORDER_COLOR:uint = 0x9e9e9e;
		private static const CANCEL_TEXT_X:uint = 14;
		private static const CANCEL_X:uint = 168;

		private static const BUTTON_FONT_FAMILY:String = "Verdana";
		private static const BUTTON_FONT_COLOR:uint = 0xf1f1f1;
		private static const BUTTON_TEXT_Y:uint = 8;
		private static const BUTTON_SIZE:uint = 14;

		private var keys:EditorKeyMan;

		private var okayButton:FancyButton;
		private var cancelButton:FancyButton;

		public function LevelPropertiesScreen(keys:EditorKeyMan) {
			this.keys = keys;

			centerSelf();
			initBG();
			initOkayButton();
			initCancelButton();

			this.visible = false;
		}

		private function centerSelf():void {
			this.x = Aeon.STAGE_WIDTH / 2 - WINDOW_WIDTH / 2;
			this.y = Aeon.STAGE_HEIGHT / 2 - WINDOW_HEIGHT / 2;
		}

		private function initBG():void {
			//inivsibile region to capture mouse events
			graphics.beginFill(0, 0);
			graphics.drawRect(-x, -y, Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT);
			graphics.endFill();

			//image
			var bg:Bitmap = new Bitmap(new LevelPropertiesBG());
			bg.x = -WINDOW_X;
			bg.y = -WINDOW_Y;
			addChild(bg);
		}

		private function drawButtonBorder(button:Sprite, color:uint, alpha:Number = 1):void {
			button.graphics.beginFill(color, alpha);
			button.graphics.drawRect(0, 0, BUTTON_WIDTH + 2, BUTTON_HEIGHT + 2);
			button.graphics.endFill();
		}

		private function drawButtonBG(button:Sprite, color:uint, alpha:Number = 1):void {
			button.graphics.beginFill(color, alpha);
			button.graphics.drawRect(1, 1, BUTTON_WIDTH, BUTTON_HEIGHT);
			button.graphics.endFill();
		}

		private function initOkayButton():void {
			var upState:Sprite = new Sprite();
			drawButtonBorder(upState, OKAY_BORDER_COLOR);
			drawButtonBG(upState, OKAY_BG_COLOR_UP);

			var overState:Sprite = new Sprite();
			drawButtonBorder(overState, OKAY_BORDER_COLOR);
			drawButtonBG(overState, OKAY_BG_COLOR_OVER);

			var hitState:Sprite = new Sprite();
			drawButtonBorder(hitState, OKAY_BORDER_COLOR, 0);
			drawButtonBG(hitState, OKAY_BG_COLOR_UP, 0);

			okayButton = new FancyButton(upState, overState, hitState);
			okayButton.x = OKAY_X - WINDOW_X;
			okayButton.y = BUTTON_Y - WINDOW_Y;
			okayButton.addEventListener(MouseEvent.CLICK, okay);
			addChild(okayButton);

			var text:TextField = new TextField();
			text.autoSize = TextFieldAutoSize.LEFT;
			text.defaultTextFormat = new TextFormat(BUTTON_FONT_FAMILY, BUTTON_SIZE, BUTTON_FONT_COLOR);
			text.selectable = false;
			text.mouseEnabled = false;
			text.text = "Okay";
			text.x = okayButton.x + OKAY_TEXT_X;
			text.y = okayButton.y + BUTTON_TEXT_Y;
			addChild(text);
		}

		private function initCancelButton():void {
			var upState:Sprite = new Sprite();
			drawButtonBorder(upState, CANCEL_BORDER_COLOR);
			drawButtonBG(upState, CANCEL_BG_COLOR_UP);

			var overState:Sprite = new Sprite();
			drawButtonBorder(overState, CANCEL_BORDER_COLOR);
			drawButtonBG(overState, CANCEL_BG_COLOR_OVER);

			var hitState:Sprite = new Sprite();
			drawButtonBorder(hitState, CANCEL_BORDER_COLOR, 0);
			drawButtonBG(hitState, CANCEL_BG_COLOR_UP, 0);

			cancelButton = new FancyButton(upState, overState, hitState);
			cancelButton.x = CANCEL_X - WINDOW_X;
			cancelButton.y = BUTTON_Y - WINDOW_Y;
			cancelButton.addEventListener(MouseEvent.CLICK, cancel);
			addChild(cancelButton);

			var text:TextField = new TextField();
			text.autoSize = TextFieldAutoSize.LEFT;
			text.defaultTextFormat = new TextFormat(BUTTON_FONT_FAMILY, BUTTON_SIZE, BUTTON_FONT_COLOR);
			text.selectable = false;
			text.mouseEnabled = false;
			text.text = "Cancel";
			text.x = cancelButton.x + CANCEL_TEXT_X;
			text.y = cancelButton.y + BUTTON_TEXT_Y;
			addChild(text);
		}

		private function okay(evt:MouseEvent = null):void {
			visible = false;
		}

		public function cancel(evt:MouseEvent = null):void {
			visible = false;
		}

		public override function set visible(value:Boolean):void {
			super.visible = value;
			if (value) {
				keys.deactivate();
				Aeon.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			} else {
				Aeon.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
				keys.activate();
			}
		}

		private function onKey(evt:KeyboardEvent):void {
			if (evt.keyCode == 27) // Esc
				visible = false;
		}
	}
}
