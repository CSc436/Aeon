package org.interguild {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;
	
	import org.interguild.game.level.LevelPage;

	public class MainMenuPage extends Page {

		private static const ANIMATION_TIMER_DELAY:uint = 75;

		//logo offset from top left
		private static const LOGO_X:uint = 70;
		private static const LOGO_Y:uint = 65;

		//selector offset from buttons
		private static const SELECTOR_X:int = -20;
		private static const SELECTOR_Y:int = -10;

		//button positions
		private static const BUTTONS_X:uint = 90;
		private static const PLAY_GAME_Y:uint = 210;
		private static const PLAY_USER_LEVELS_Y:uint = PLAY_GAME_Y + 60;
		private static const LEVEL_EDITOR_Y:uint = PLAY_USER_LEVELS_Y + 60;
		private static const OPTIONS_Y:uint = LEVEL_EDITOR_Y + 60;

		//enums for which page is selected
		private static const TODO_PLAY_GAME:uint = 0x0;
		private static const TODO_PLAY_LEVELS:uint = 0x1;
		private static const TODO_LEVEL_EDITOR:uint = 0x2;
		private static const TODO_OPTIONS:uint = 0x3;
		private static const NUMBER_OF_MENU_BUTTONS:uint = 4;

		//offset from bottom right of screen
		private static const CREDIT_PADDING_X:uint = 10;
		private static const CREDIT_PADDING_Y:uint = 10;

		//offset from top right of screen
		private static const LOGIN_PADDING_X:uint = 10;
		private static const LOGIN_PADDING_Y:uint = 10;

		//hyperlink colors
		private static const LINK_NORMAL_COLOR:uint = 0x00daf2;
		private static const LINK_DOWN_COLOR:uint = 0x97ffed;
		private static const COPYRIGHT:String = "© 2014 Interguild.org";

		private var buttonSelect:Bitmap;
		private var buttonClick:Bitmap;

		private var animTimer:Timer;

		private var selectedButton:int = 0;
		private var listOfButtons:Array;

		private var creditText:TextField;
		private var logoutText:TextField;
		
		private var isEnabled:Boolean = true;

		public function MainMenuPage() {
			//init logo image
			var logo:MovieClip = new AeonLogo();
			logo.x = LOGO_X;
			logo.y = LOGO_Y;
			this.addChild(logo);

			//init selectors
			buttonSelect = new Bitmap(new MenuButtonSelectBG());
			buttonClick = new Bitmap(new MenuButtonClickBG());
			buttonSelect.visible = false;
			buttonClick.visible = false;
			addChild(buttonSelect);
			addChild(buttonClick);

			listOfButtons = new Array();

			//int play game button
			var playButton:MovieClip = new PlayGameButton();
			playButton.buttonMode = true;
			playButton.x = BUTTONS_X;
			playButton.y = PLAY_GAME_Y;
			playButton.addEventListener(MouseEvent.CLICK, gotoGame);
			playButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			playButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			playButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addChild(playButton);
			listOfButtons.push(playButton);

			//int play user levels button
			var playLevels:MovieClip = new PlayUserLevelsButton();
			playLevels.buttonMode = true;
			playLevels.x = BUTTONS_X;
			playLevels.y = PLAY_USER_LEVELS_Y;
			playLevels.addEventListener(MouseEvent.CLICK, gotoLevels);
			playLevels.addEventListener(MouseEvent.CLICK, onMouseClick);
			playLevels.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			playLevels.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addChild(playLevels);
			listOfButtons.push(playLevels);

			//init editor button
			var editorButton:MovieClip = new LevelEditorButton();
			editorButton.buttonMode = true;
			editorButton.x = BUTTONS_X;
			editorButton.y = LEVEL_EDITOR_Y;
			editorButton.addEventListener(MouseEvent.CLICK, gotoEditor);
			editorButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			editorButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			editorButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addChild(editorButton);
			listOfButtons.push(editorButton);

			//int play user levels button
			var optionsButton:MovieClip = new OptionsButton();
			optionsButton.buttonMode = true;
			optionsButton.x = BUTTONS_X;
			optionsButton.y = OPTIONS_Y;
			optionsButton.addEventListener(MouseEvent.CLICK, gotoOptions);
			optionsButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			optionsButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			optionsButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addChild(optionsButton);
			listOfButtons.push(optionsButton);

			animTimer = new Timer(ANIMATION_TIMER_DELAY);
			animTimer.addEventListener(TimerEvent.TIMER, handleClick);

			buttonSelect.x = playButton.x + SELECTOR_X;
			buttonSelect.y = playButton.y + SELECTOR_Y;
			buttonSelect.visible = true;

			KeyMan.getMe().addMenuCallback(onKeyDown);

			//init credits
			creditText = new TextField();
			creditText.defaultTextFormat = new TextFormat("Verdana", 12, LINK_NORMAL_COLOR);
			creditText.autoSize = TextFieldAutoSize.LEFT;
			creditText.selectable = false;
			creditText.text = "Credits";
			creditText.x = Aeon.STAGE_WIDTH - creditText.width - CREDIT_PADDING_X;
			creditText.y = Aeon.STAGE_HEIGHT - creditText.height - CREDIT_PADDING_Y;
			creditText.addEventListener(MouseEvent.CLICK, onLinkClick);
			creditText.addEventListener(MouseEvent.MOUSE_DOWN, onCreditsDown);
			creditText.addEventListener(MouseEvent.MOUSE_OVER, onLinkOver);
			creditText.addEventListener(MouseEvent.MOUSE_OUT, onLinkOut);
			addChild(creditText);

			//init copyright
			var copyText:TextField = new TextField();
			copyText.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			copyText.autoSize = TextFieldAutoSize.LEFT;
			copyText.selectable = false;
			copyText.text = COPYRIGHT + "  | ";
			copyText.x = creditText.x - copyText.width;
			copyText.y = creditText.y;
			addChild(copyText);
			
			//init logout
			logoutText = new TextField();
			logoutText.defaultTextFormat = new TextFormat("Verdana", 12, LINK_NORMAL_COLOR);
			logoutText.autoSize = TextFieldAutoSize.LEFT;
			logoutText.selectable = false;
			logoutText.text = "Log Out";
			logoutText.addEventListener(MouseEvent.CLICK, onLinkClick);
			logoutText.addEventListener(MouseEvent.MOUSE_DOWN, onCreditsDown);
			logoutText.addEventListener(MouseEvent.MOUSE_OVER, onLinkOver);
			logoutText.addEventListener(MouseEvent.MOUSE_OUT, onLinkOut);
			logoutText.x = Aeon.STAGE_WIDTH - logoutText.width - LOGIN_PADDING_X;
			logoutText.y = LOGIN_PADDING_Y;
			addChild(logoutText);

			//init login
			var loginText:TextField = new TextField();
			loginText.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			loginText.autoSize = TextFieldAutoSize.LEFT;
			loginText.selectable = false;
//			loginText.text = "Log in to rate and share levels.";
			loginText.text = "Welcome, UsernameGoesHere!";
			loginText.x = logoutText.x - loginText.width;
			loginText.y = LOGIN_PADDING_Y;
			addChild(loginText);
		}

		private function gotoGame(event:MouseEvent):void {
			selectedButton = TODO_PLAY_GAME;
		}

		private function gotoLevels(event:MouseEvent):void {
			selectedButton = TODO_PLAY_LEVELS;
		}

		private function gotoEditor(evt:MouseEvent):void {
			selectedButton = TODO_LEVEL_EDITOR;
		}

		private function gotoOptions(event:MouseEvent):void {
			selectedButton = TODO_OPTIONS;
		}

		private function onMouseClick(evt:MouseEvent):void {
			handleClick();
		}

		private function onMouseDown(evt:MouseEvent):void {
			simMouseDown(MovieClip(evt.target));
		}

		private function simMouseDown(t:MovieClip):void {
			buttonClick.x = t.x + SELECTOR_X;
			buttonClick.y = t.y + SELECTOR_Y;
			buttonClick.visible = true;
			buttonSelect.visible = false;
		}

		private function pressItem(t:MovieClip):void {
			simMouseDown(t);
			animTimer.start();
		}

		private function handleClick(evt:TimerEvent = null):void {
			animTimer.stop();
			buttonSelect.visible = true;
			buttonClick.visible = false;
			switch (selectedButton) {
				case TODO_PLAY_GAME:
					Aeon.getMe().playLevelFile(LevelPage.TEST_LEVEL_FILE);
					break;
				case TODO_PLAY_LEVELS:
					break;
				case TODO_LEVEL_EDITOR:
					Aeon.getMe().gotoEditorPage();
					break;
				case TODO_OPTIONS:
					break;
			}
		}

		private function onMouseOver(evt:MouseEvent):void {
			var t:MovieClip = MovieClip(evt.target);
			selectedButton = listOfButtons.indexOf(t);
			selectItem(MovieClip(evt.target));
		}

		private function onKeyDown(keyCode:uint):void {
			if(!isEnabled)
				return;
			switch (keyCode) {
				case 40: //down arrow key
					selectedButton++;
					if (selectedButton >= NUMBER_OF_MENU_BUTTONS)
						selectedButton = 0;
					selectItem(MovieClip(listOfButtons[selectedButton]));
					break;
				case 38: //up arrow key
					selectedButton--;
					if (selectedButton < 0)
						selectedButton = NUMBER_OF_MENU_BUTTONS - 1;
					selectItem(MovieClip(listOfButtons[selectedButton]));
					break;
				case 32: //spacebar
				case 13: //enter
					pressItem(MovieClip(listOfButtons[selectedButton]));
					break;
			}
		}

		private function selectItem(t:MovieClip):void {
			buttonSelect.x = t.x + SELECTOR_X;
			buttonSelect.y = t.y + SELECTOR_Y;
			buttonSelect.visible = true;
			buttonClick.visible = false;
		}

		private function onLinkOver(evt:MouseEvent):void {
			var t:TextField = TextField(evt.target);
			var f:TextFormat = t.defaultTextFormat;
			f.underline = true;
			t.setTextFormat(f);
			Mouse.cursor = MouseCursor.BUTTON;
		}

		private function onLinkOut(evt:MouseEvent):void {
			var t:TextField = TextField(evt.target);
			var f:TextFormat = t.defaultTextFormat;
			f.underline = false;
			t.setTextFormat(f);
			Mouse.cursor = MouseCursor.AUTO;
		}

		private function onCreditsDown(evt:MouseEvent):void {
			var t:TextField = TextField(evt.target);
			var f:TextFormat = t.defaultTextFormat;
			f.color = LINK_DOWN_COLOR;
			f.underline = true;
			t.setTextFormat(f);
		}

		private function onLinkClick(evt:MouseEvent):void {
			var t:TextField = TextField(evt.target);
			var f:TextFormat = t.defaultTextFormat;
			f.color = LINK_NORMAL_COLOR;
			f.underline = true;
			t.setTextFormat(f);
		}
		
		public override function set visible(b:Boolean):void{
			super.visible = b;
			isEnabled = b;
		}
	}
}
