package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import fl.controls.TextInput;

	import org.interguild.Aeon;
	import org.interguild.editor.levelpane.EditorLevel;
	import org.interguild.editor.levelpane.EditorLevelPane;
	import org.interguild.menu.BetterTextInput;
	import org.interguild.menu.FancyButton;

	public class LevelPropertiesScreen extends Sprite {

		private static const WINDOW_X:uint = 21;
		private static const WINDOW_Y:uint = 15;
		private static const WINDOW_WIDTH:uint = 275;
		private static const WINDOW_HEIGHT:uint = 371;

		private static const BUTTON_WIDTH:Number = 78;
		private static const BUTTON_HEIGHT:Number = 37;
		private static const BUTTON_Y:Number = 325;

		private static const OKAY_BG_COLOR_UP:uint = 0x116e79; //0x008173;
		private static const OKAY_BG_COLOR_OVER:uint = 0x1498a8; //0x009b8b;
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

		private static const TEXT_FONT:String = "Verdana";
		private static const TEXT_SIZE:Number = 14;
		private static const TEXT_COLOR:uint = 0xFFFFFF;

		private static const TITLE_TEXT_X:Number = 76;
		private static const TITLE_TEXT_Y:Number = 100;
		private static const TITLE_INPUT_X:Number = 122;
		private static const TITLE_INPUT_Y:Number = 101;
		private static const TITLE_INPUT_WIDTH:Number = 128;

		private static const INPUT_HEIGHT:Number = 22;

		private static const SIZE_TEXT_X:Number = 76;
		private static const SIZE_TEXT_Y:Number = 142;
		private static const SIZE_BY_TEXT_X:Number = 179;
		private static const SIZE_BY_TEXT_Y:Number = 145;
		private static const SIZE_WIDTH_INPUT_X:Number = 122;
		private static const SIZE_HEIGHT_INPUT_X:Number = 200;
		private static const SIZE_INPUT_Y:Number = 143;
		private static const SIZE_INPUT_WIDTH:Number = 50;

		private static const TERRAIN_TEXT_X:Number = 61;
		private static const TERRAIN_TEXT_Y:Number = 193;

		private static const BG_TEXT_X:Number = 65;
		private static const BG_TEXT_Y:Number = 256;

		private static const SHADOW_DISTANCE:Number = 2;
		private static const SHADOW_ANGLE:Number = 60;
		private static const SHADOW_COLOR:uint = 0x000000;
		private static const SHADOW_ALPHA:Number = 0.75;
		private static const SHADOW_BLUR_X:Number = 1;
		private static const SHADOW_BLUE_Y:Number = 1;
		private static const SHADOW_STRENGTH:Number = 1;

		private var keys:EditorKeyMan;
		private var levelPane:EditorLevelPane;
		private var currentLevel:EditorLevel;

		private var titleInput:TextInput;
		private var sizeWidthInput:TextInput;
		private var sizeHeightInput:TextInput;

		private var okayButton:FancyButton;
		private var cancelButton:FancyButton;

		public function LevelPropertiesScreen(keys:EditorKeyMan, levelPane:EditorLevelPane) {
			this.keys = keys;
			this.levelPane = levelPane;

			centerSelf();
			initBG();
			initOkayButton();
			initCancelButton();
			initText();
			initForms();

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

		private function initText():void {
			var format:TextFormat = new TextFormat(TEXT_FONT, TEXT_SIZE, TEXT_COLOR);
			var dropShadow:DropShadowFilter = new DropShadowFilter(SHADOW_DISTANCE, SHADOW_ANGLE, SHADOW_COLOR, SHADOW_ALPHA, SHADOW_BLUR_X, SHADOW_BLUE_Y, SHADOW_STRENGTH);

			var title:TextField = new TextField();
			title.defaultTextFormat = format;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.selectable = false;
			title.mouseEnabled = false;
			title.filters = [dropShadow];
			title.text = "Title:";
			title.x = TITLE_TEXT_X - WINDOW_X;
			title.y = TITLE_TEXT_Y - WINDOW_Y;
			addChild(title);

			var size:TextField = new TextField();
			size.defaultTextFormat = format;
			size.autoSize = TextFieldAutoSize.LEFT;
			size.selectable = false;
			size.mouseEnabled = false;
			size.filters = [dropShadow];
			size.text = "Size:";
			size.x = SIZE_TEXT_X - WINDOW_X;
			size.y = SIZE_TEXT_Y - WINDOW_Y;
			addChild(size);
			addChild(title);

			var sizeBy:TextField = new TextField();
			sizeBy.defaultTextFormat = format;
			sizeBy.autoSize = TextFieldAutoSize.LEFT;
			sizeBy.selectable = false;
			sizeBy.mouseEnabled = false;
			sizeBy.filters = [dropShadow];
			sizeBy.text = "x";
			sizeBy.x = SIZE_BY_TEXT_X - WINDOW_X;
			sizeBy.y = SIZE_BY_TEXT_Y - WINDOW_Y;
			addChild(sizeBy);

			var terrain:TextField = new TextField();
			terrain.defaultTextFormat = format;
			terrain.autoSize = TextFieldAutoSize.LEFT;
			terrain.selectable = false;
			terrain.mouseEnabled = false;
			terrain.filters = [dropShadow];
			terrain.text = "Terrain Type:";
			terrain.x = TERRAIN_TEXT_X - WINDOW_X;
			terrain.y = TERRAIN_TEXT_Y - WINDOW_Y;
			addChild(terrain);

			var background:TextField = new TextField();
			background.defaultTextFormat = format;
			background.autoSize = TextFieldAutoSize.LEFT;
			background.selectable = false;
			background.mouseEnabled = false;
			background.filters = [dropShadow];
			background.text = "Background:";
			background.x = BG_TEXT_X - WINDOW_X;
			background.y = BG_TEXT_Y - WINDOW_Y;
			addChild(background);
		}

		private function initForms():void {
			titleInput = new BetterTextInput();
			titleInput.x = TITLE_INPUT_X - WINDOW_X;
			titleInput.y = TITLE_INPUT_Y - WINDOW_Y;
			titleInput.width = TITLE_INPUT_WIDTH;
			titleInput.height = INPUT_HEIGHT;
			addChild(titleInput);

			sizeWidthInput = new BetterTextInput();
			sizeWidthInput.x = SIZE_WIDTH_INPUT_X - WINDOW_X;
			sizeWidthInput.y = SIZE_INPUT_Y - WINDOW_Y;
			sizeWidthInput.width = SIZE_INPUT_WIDTH;
			sizeWidthInput.height = INPUT_HEIGHT;
			sizeWidthInput.maxChars = 4;
			sizeWidthInput.restrict = "1234567890";
			addChild(sizeWidthInput);

			sizeHeightInput = new BetterTextInput();
			sizeHeightInput.x = SIZE_HEIGHT_INPUT_X - WINDOW_X;
			sizeHeightInput.y = SIZE_INPUT_Y - WINDOW_Y;
			sizeHeightInput.width = SIZE_INPUT_WIDTH;
			sizeHeightInput.height = INPUT_HEIGHT;
			sizeHeightInput.maxChars = 4;
			sizeHeightInput.restrict = "1234567890";
			addChild(sizeHeightInput);

			//titleInput.restrict("0123456789");

			this.addEventListener(MouseEvent.CLICK, onFocusClick);
		}

		private function updateForms():void {
			titleInput.text = String(currentLevel.title);
			sizeWidthInput.text = String(currentLevel.widthInTiles);
			sizeHeightInput.text = String(currentLevel.heightInTiles);
		}

		private function onFocusClick(evt:MouseEvent):void {
			if (!(evt.target is TextInput) && !(evt.target is TextField)) {
				stage.focus = stage;
			}
		}

		private function okay(evt:MouseEvent = null):void {
			visible = false;
			currentLevel.title = titleInput.text;
			currentLevel.resize(Number(sizeHeightInput.text), Number(sizeWidthInput.text));
		}

		public function cancel(evt:MouseEvent = null):void {
			visible = false;
		}

		public override function set visible(value:Boolean):void {
			super.visible = value;
			if (value) {
				keys.deactivate();
				Aeon.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
				currentLevel = levelPane.level;
				updateForms();
			} else {
				Aeon.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
				keys.activate();
			}
		}

		private function onKey(evt:KeyboardEvent):void {
			switch(evt.keyCode){
				case 27: // Esc
					visible = false;
					break;
				case 13: // ENTER
					okay();
					break;
			}
		}
	}
}
