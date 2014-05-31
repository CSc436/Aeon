package org.interguild.menu {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import org.interguild.Aeon;
	import org.interguild.User;
	import org.interguild.game.gui.LevelPage;

	public class MainMenuPage extends ListBasedMenu {

		private static const CENTER_X:Number = Aeon.STAGE_WIDTH / 2;

		//logo offset from top left
//		private static const LOGO_X:uint = 70;
		private static const LOGO_Y:uint = 60;

		//selector offset from buttons
//		private static const SELECTOR_X:int = -16;
		private static const SELECTOR_Y:int = -7;

		//button positions
//		private static const BUTTONS_X:uint = 90;
		private static const PLAY_GAME_Y:uint = LOGO_Y + 145;
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

		//offset from bottom left of screen
		private static const LOGIN_PADDING_X:uint = 10;
		private static const LOGIN_PADDING_Y:uint = 10;

		//hyperlink colors
		private static const LINK_NORMAL_COLOR:uint = 0x00daf2;
		private static const LINK_DOWN_COLOR:uint = 0x97ffed;

		private static const LOGGED_OUT_TEXT:String = "to rate and share levels.";
		private static const COPYRIGHT:String = "© 2014 Interguild.org";

		private static const LOGOUT_URL:String = "http://interguild.org/logout.php";
		private static const LOGIN_URL:String = "http://interguild.org/login.php";

		private var creditLink:TextField;
		private var userText:TextField;
		private var loginLink:TextField;
		private var logoutLink:TextField;

		public function MainMenuPage() {
			super(CENTER_X, SELECTOR_Y);

			initMainItems();
			initSideItems();
		}

		private function initMainItems():void {
			//init bg image
			this.addChildAt(new Bitmap(new MainMenuBG()), 0); //numChildren - 1);

			//init logo image
			var logo:MovieClip = new AeonLogo();
			logo.x = CENTER_X;
			logo.y = LOGO_Y;
			this.addChild(logo);

			//int play game button
			var playButton:MovieClip = new PlayGameButton();
			playButton.buttonMode = true;
			playButton.x = CENTER_X;
			playButton.y = PLAY_GAME_Y;
			this.addChild(playButton);
			addButton(playButton);

			//int play user levels button
			var playLevels:MovieClip = new PlayUserLevelsButton();
			playLevels.buttonMode = true;
			playLevels.x = CENTER_X;
			playLevels.y = PLAY_USER_LEVELS_Y;
			this.addChild(playLevels);
			addButton(playLevels);

			//init editor button
			var editorButton:MovieClip = new LevelEditorButton();
			editorButton.buttonMode = true;
			editorButton.x = CENTER_X;
			editorButton.y = LEVEL_EDITOR_Y;
			this.addChild(editorButton);
			addButton(editorButton);

			//int play user levels button
			var optionsButton:MovieClip = new OptionsButton();
			optionsButton.buttonMode = true;
			optionsButton.x = CENTER_X;
			optionsButton.y = OPTIONS_Y;
			this.addChild(optionsButton);
			addButton(optionsButton);

			selectItem(playButton);
		}

		private function initSideItems():void {
			var linkFormat:TextFormat = new TextFormat("Verdana", 12, LINK_NORMAL_COLOR);
			var textFormat:TextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);

			//init credits
			creditLink = new TextField();
			creditLink.defaultTextFormat = linkFormat;
			creditLink.autoSize = TextFieldAutoSize.LEFT;
			creditLink.selectable = false;
			creditLink.text = "Credits";
			creditLink.x = Aeon.STAGE_WIDTH - creditLink.width - CREDIT_PADDING_X;
			creditLink.y = Aeon.STAGE_HEIGHT - creditLink.height - CREDIT_PADDING_Y;
			creditLink.addEventListener(MouseEvent.MOUSE_DOWN, onLinkDown);
			creditLink.addEventListener(MouseEvent.MOUSE_UP, onLinkUp);
			creditLink.addEventListener(MouseEvent.MOUSE_OVER, onLinkOver);
			creditLink.addEventListener(MouseEvent.MOUSE_OUT, onLinkOut);
			addChild(creditLink);

			//init copyright
			var copyText:TextField = new TextField();
			copyText.defaultTextFormat = textFormat;
			copyText.autoSize = TextFieldAutoSize.LEFT;
			copyText.selectable = false;
			copyText.text = COPYRIGHT + "  | ";
			copyText.x = creditLink.x - copyText.width;
			copyText.y = creditLink.y;
			addChild(copyText);
			
			//init user text // displays welcome message, or login link
			userText = new TextField();
			userText.defaultTextFormat = textFormat;
			userText.autoSize = TextFieldAutoSize.LEFT;
			userText.selectable = false;
			userText.text = "Welcome.";
			userText.y = Aeon.STAGE_HEIGHT - userText.height - LOGIN_PADDING_Y;
			userText.visible = false;
			addChild(userText);

			//init logout
			logoutLink = new TextField();
			logoutLink.defaultTextFormat = linkFormat;
			logoutLink.autoSize = TextFieldAutoSize.LEFT;
			logoutLink.selectable = false;
			logoutLink.text = "Log Out";
			logoutLink.addEventListener(MouseEvent.MOUSE_DOWN, onLinkDown);
			logoutLink.addEventListener(MouseEvent.MOUSE_UP, onLinkUp);
			logoutLink.addEventListener(MouseEvent.MOUSE_OVER, onLinkOver);
			logoutLink.addEventListener(MouseEvent.MOUSE_OUT, onLinkOut);
			logoutLink.addEventListener(MouseEvent.CLICK, onLogoutClick);
			logoutLink.y = userText.y;
			logoutLink.visible = false;
			addChild(logoutLink);

			//init login
			loginLink = new TextField();
			loginLink.defaultTextFormat = linkFormat;
			loginLink.autoSize = TextFieldAutoSize.LEFT;
			loginLink.selectable = false;
			loginLink.text = "Log in";
			loginLink.addEventListener(MouseEvent.MOUSE_DOWN, onLinkDown);
			loginLink.addEventListener(MouseEvent.MOUSE_UP, onLinkUp);
			loginLink.addEventListener(MouseEvent.MOUSE_OVER, onLinkOver);
			loginLink.addEventListener(MouseEvent.MOUSE_OUT, onLinkOut);
			loginLink.addEventListener(MouseEvent.CLICK, onLoginClick);
			loginLink.y = userText.y;
			loginLink.visible = false;
			addChild(loginLink);

			Aeon.STAGE.focus = Aeon.STAGE;
			Aeon.STAGE.addEventListener(FocusEvent.FOCUS_OUT, listenForChange);
		}

		/**
		 * Called when get_login.php has loaded, so that we can
		 * see if the user is logged in.
		 */
		public function updateUser():void {
			if (User.IS_LOGGED_IN) {
				loginLink.visible = false;
				
				userText.text = "Welcome, " + User.NAME + "!";
				userText.x = LOGIN_PADDING_X;
				userText.visible = true;
				
				logoutLink.x = userText.x + userText.width;
				logoutLink.visible = true;
			} else {
				logoutLink.visible = false;
				
				loginLink.x = userText.x + userText.width;
				loginLink.x = LOGIN_PADDING_X;
				loginLink.visible = true;
				
				userText.text = LOGGED_OUT_TEXT;
				userText.x = loginLink.x + loginLink.width;
				userText.visible = true;
			}
		}

		private function onLoginClick(evt:MouseEvent):void {
			navigateToURL(new URLRequest(LOGIN_URL), "_blank");
//			listenForChange();
		}

		private function onLogoutClick(evt:MouseEvent):void {
			navigateToURL(new URLRequest(LOGOUT_URL), "_blank");
//			listenForChange();
		}

		private function listenForChange(evt:FocusEvent = null):void {
			trace("lost focus");
			stage.removeEventListener(FocusEvent.FOCUS_OUT, listenForChange);
			stage.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onFocus);

			function onFocus(evt:Event = null):void {
				stage.removeEventListener(FocusEvent.FOCUS_IN, onFocus);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onFocus);
				stage.addEventListener(FocusEvent.FOCUS_OUT, listenForChange);

				User.init(updateUser);
				trace("FOCUS");
			}
		}

		protected override function onItemClicked(selectedButton:uint):void {
			switch (selectedButton) {
				case TODO_PLAY_GAME:
					Aeon.getMe().playLevelFile(LevelPage.TEST_LEVEL_FILE);
					break;
				case TODO_PLAY_LEVELS:
					Aeon.getMe().gotoUserLevels();
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

		private function onLinkDown(evt:MouseEvent):void {
			var t:TextField = TextField(evt.target);
			var f:TextFormat = t.defaultTextFormat;
			f.color = LINK_DOWN_COLOR;
			f.underline = true;
			t.setTextFormat(f);
		}

		private function onLinkUp(evt:MouseEvent):void {
			var t:TextField = TextField(evt.target);
			var f:TextFormat = t.defaultTextFormat;
			f.color = LINK_NORMAL_COLOR;
			f.underline = true;
			t.setTextFormat(f);
		}
	}
}
