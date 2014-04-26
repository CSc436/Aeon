package org.interguild {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	CONFIG::DEPLOY {
		import org.interguild.game.level.TestLevel;
	}
	CONFIG::NODEPLOY {
		import org.interguild.game.level.LevelPage;
	}

	public class MainMenuPage extends ListBasedMenu {

		//logo offset from top left
		private static const LOGO_X:uint = 70;
		private static const LOGO_Y:uint = 65;

		//selector offset from buttons
		private static const SELECTOR_X:int = -16;
		private static const SELECTOR_Y:int = -7;

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

		private var creditText:TextField;
		private var logoutText:TextField;

		public function MainMenuPage() {
			super(SELECTOR_X, SELECTOR_Y);
			
			//init logo image
			var logo:MovieClip = new AeonLogo();
			logo.x = LOGO_X;
			logo.y = LOGO_Y;
			this.addChild(logo);

			//int play game button
			var playButton:MovieClip = new PlayGameButton();
			playButton.buttonMode = true;
			playButton.x = BUTTONS_X;
			playButton.y = PLAY_GAME_Y;
			this.addChild(playButton);
			addButton(playButton);

			//int play user levels button
			var playLevels:MovieClip = new PlayUserLevelsButton();
			playLevels.buttonMode = true;
			playLevels.x = BUTTONS_X;
			playLevels.y = PLAY_USER_LEVELS_Y;
			this.addChild(playLevels);
			addButton(playLevels);

			//init editor button
			var editorButton:MovieClip = new LevelEditorButton();
			editorButton.buttonMode = true;
			editorButton.x = BUTTONS_X;
			editorButton.y = LEVEL_EDITOR_Y;
			this.addChild(editorButton);
			addButton(editorButton);

			//int play user levels button
			var optionsButton:MovieClip = new OptionsButton();
			optionsButton.buttonMode = true;
			optionsButton.x = BUTTONS_X;
			optionsButton.y = OPTIONS_Y;
			this.addChild(optionsButton);
			addButton(optionsButton);

			selectItem(playButton);

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

		protected override function onItemClicked(selectedButton:uint):void{
			switch (selectedButton) {
				case TODO_PLAY_GAME:
					CONFIG::DEPLOY {
					Aeon.getMe().playLevelCode(TestLevel.getCode());
				}
					CONFIG::NODEPLOY {
					Aeon.getMe().playLevelFile(LevelPage.TEST_LEVEL_FILE);
				}
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
	}
}
