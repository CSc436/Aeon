package org.interguild.editor.levelprops {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import fl.controls.TextInput;

	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.components.BetterTextInput;
	import org.interguild.components.FancyButton;
	import org.interguild.components.SquareButton;
	import org.interguild.editor.EditorKeyMan;
	import org.interguild.editor.EditorPage;
	import org.interguild.editor.history.ChangedProperties;
	import org.interguild.editor.levelpane.EditorLevel;
	import org.interguild.editor.levelpane.EditorLevelPane;
	import org.interguild.game.LevelBackground;
	import org.interguild.game.tiles.Terrain;

	public class LevelPropertiesScreen extends Sprite {

		private static const WINDOW_X:uint = 21;
		private static const WINDOW_Y:uint = 15;
		private static const WINDOW_WIDTH:uint = 275;
		private static const WINDOW_HEIGHT:uint = 371;

		private static const BUTTON_WIDTH:Number = 78;
		private static const BUTTON_HEIGHT:Number = 37;
		private static const BUTTON_Y:Number = 325;

		private static const OKAY_BG_COLOR_UP:uint = 0x116e79;
		private static const OKAY_BG_COLOR_OVER:uint = 0x1498a8;
		private static const OKAY_BORDER_COLOR:uint = 0x48daff;
		private static const OKAY_X:uint = 72;

		private static const CANCEL_BG_COLOR_UP:uint = 0x4b4b4b;
		private static const CANCEL_BG_COLOR_OVER:uint = 0x676767;
		private static const CANCEL_BORDER_COLOR:uint = 0x9e9e9e;
		private static const CANCEL_X:uint = 168;

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

		private static const DROPDOWN_INPUT_X:uint = 170;
		private static const TERRAIN_INPUT_Y:uint = 185;
		private static const BG_INPUT_Y:uint = 247;

		private var keys:EditorKeyMan;
		private var levelPane:EditorLevelPane;
		private var currentLevel:EditorLevel;

		private var titleInput:TextInput;
		private var sizeWidthInput:TextInput;
		private var sizeHeightInput:TextInput;
		private var terrainDropdown:PictureMenu;
		private var backgroundDropdown:PictureMenu;
		private var originalTerrainID:uint;
		private var originalBackgroundID:uint;

		private var okayButton:FancyButton;
		private var cancelButton:FancyButton;

		public function LevelPropertiesScreen(keys:EditorKeyMan, levelPane:EditorLevelPane) {
			this.keys = keys;
			this.levelPane = levelPane;

			centerSelf();
			initBG();
			initButtons();
			initText();
			initTextInputs();
			initDropdowns();

			this.visible = false;
		}

		private function centerSelf():void {
			this.x = Aeon.STAGE_WIDTH / 2 - WINDOW_WIDTH / 2;
			this.y = Aeon.STAGE_HEIGHT / 2 - WINDOW_HEIGHT / 2;
		}

		private function initBG():void {
			//inivsibile region to capture mouse events
			graphics.beginFill(0, EditorPage.OVERLAY_ALPHA);
			graphics.drawRect(-x, -y, Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT);
			graphics.endFill();

			//image
			var bg:Bitmap = new Bitmap(Assets.LEVEL_PROPERTIES_BG);
			bg.x = -WINDOW_X;
			bg.y = -WINDOW_Y;
			addChild(bg);
		}

		private function initButtons():void {
			okayButton = new SquareButton("Okay", OKAY_BG_COLOR_UP, OKAY_BG_COLOR_OVER, OKAY_BORDER_COLOR, BUTTON_WIDTH, BUTTON_HEIGHT);
			okayButton.x = OKAY_X - WINDOW_X;
			okayButton.y = BUTTON_Y - WINDOW_Y;
			okayButton.addEventListener(MouseEvent.CLICK, okay);
			addChild(okayButton);

			cancelButton = new SquareButton("Cancel", CANCEL_BG_COLOR_UP, CANCEL_BG_COLOR_OVER, CANCEL_BORDER_COLOR, BUTTON_WIDTH, BUTTON_HEIGHT);
			cancelButton.x = CANCEL_X - WINDOW_X;
			cancelButton.y = BUTTON_Y - WINDOW_Y;
			cancelButton.addEventListener(MouseEvent.CLICK, cancel);
			addChild(cancelButton);
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

		private function initTextInputs():void {
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

			this.addEventListener(MouseEvent.CLICK, onFocusClick);
		}

		private function initDropdowns():void {
			//terrain type:
			terrainDropdown = new PictureMenu(this);
			var i:uint = 0;
			var image:BitmapData;
			var name:String;
			while (true) {
				image = Assets.getTerrainImage(i);
				name = Assets.getTerrainName(i);
				if (image == null || name == null)
					break;
				terrainDropdown.addItem(i, image, name);
				i++;
			}
			addChild(terrainDropdown);
			terrainDropdown.x = DROPDOWN_INPUT_X - WINDOW_X; //must be done after addChild();
			terrainDropdown.y = TERRAIN_INPUT_Y - WINDOW_Y;
			terrainDropdown.addEventListener(Event.CHANGE, onPictureMenuChange);

			//background type:
			backgroundDropdown = new PictureMenu(this);
			i = 0;
			while (true) {
				image = Assets.getBGThumbnail(i);
				name = Assets.getBGName(i);
				if (image == null || name == null)
					break;
				backgroundDropdown.addItem(i, image, name);
				i++;
			}
			addChild(backgroundDropdown);
			backgroundDropdown.x = DROPDOWN_INPUT_X - WINDOW_X; //must be done after addChild();
			backgroundDropdown.y = BG_INPUT_Y - WINDOW_Y;
			backgroundDropdown.addEventListener(Event.CHANGE, onPictureMenuChange);
		}

		private function onPictureMenuChange(evt:Event):void {
			if (evt.target == terrainDropdown) {
				currentLevel.terrainType = terrainDropdown.currentID;
			} else {
				currentLevel.backgroundType = backgroundDropdown.currentID;
			}
		}

		private function updateForms():void {
			titleInput.text = String(currentLevel.title);
			sizeWidthInput.text = String(currentLevel.widthInTiles);
			sizeHeightInput.text = String(currentLevel.heightInTiles);
			terrainDropdown.currentID = currentLevel.terrainType;
			backgroundDropdown.currentID = currentLevel.backgroundType;
			originalTerrainID = currentLevel.terrainType;
			originalBackgroundID = currentLevel.backgroundType;
		}

		private function onFocusClick(evt:MouseEvent):void {
			if (!(evt.target is TextInput) && !(evt.target is TextField)) {
				stage.focus = stage;
			}
		}

		private function okay(evt:MouseEvent = null):void {
			visible = false;
			var c:ChangedProperties = new ChangedProperties();
			c.changeTitle(currentLevel.title, titleInput.text);
//			currentLevel.title = titleInput.text;
			c.changeWidth(currentLevel.widthInTiles, Number(sizeWidthInput.text));
			c.changeHeight(currentLevel.heightInTiles, Number(sizeHeightInput.text));
			c.prepareResize();
			c.changeTerrain(originalTerrainID, terrainDropdown.currentID);
			c.changeBackground(originalBackgroundID, backgroundDropdown.currentID);
//			currentLevel.resize(Number(sizeHeightInput.text), Number(sizeWidthInput.text));

			if (c.hasChanges()) {
				c.doChange(currentLevel);
				currentLevel.history.addHistory(c);
			}
		}

		public function cancel(evt:MouseEvent = null):void {
			visible = false;
			currentLevel.terrainType = originalTerrainID;
			currentLevel.backgroundType = originalBackgroundID;
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
			switch (evt.keyCode) {
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
