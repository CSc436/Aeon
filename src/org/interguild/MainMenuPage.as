package org.interguild {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.interguild.game.level.LevelPage;

	public class MainMenuPage extends Page {

		private static const LOGO_X:uint = 70;
		private static const LOGO_Y:uint = 75;
		
		private static const SELECTOR_X:int = -20;
		private static const SELECTOR_Y:int = -10;

		private static const BUTTONS_X:uint = 90;
		private static const PLAY_GAME_Y:uint = 215;
		private static const PLAY_USER_LEVELS_Y:uint = 275;
		private static const LEVEL_EDITOR_Y:uint = 335;
		private static const OPTIONS_Y:uint = 395;
		
		private var buttonSelect:Bitmap;
		private var buttonClick:Bitmap;

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

			//int play game button
			var playButton:MovieClip = new PlayGameButton();
			playButton.buttonMode = true;
			playButton.x = BUTTONS_X;
			playButton.y = PLAY_GAME_Y;
			playButton.addEventListener(MouseEvent.CLICK, gotoGame);
			playButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			playButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			playButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addChild(playButton);
			
			//int play user levels button
			var playLevels:MovieClip = new PlayUserLevelsButton();
			playLevels.buttonMode = true;
			playLevels.x = BUTTONS_X;
			playLevels.y = PLAY_USER_LEVELS_Y;
			playLevels.addEventListener(MouseEvent.CLICK, onMouseClick);
			playLevels.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			playLevels.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addChild(playLevels);

			//init editor button
			var editorButton:MovieClip = new LevelEditorButton();
			editorButton.buttonMode = true;
			editorButton.x = BUTTONS_X;
			editorButton.y = LEVEL_EDITOR_Y;
			editorButton.addEventListener(MouseEvent.CLICK, gotoEditor);
			editorButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			editorButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			editorButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addChild(editorButton);
			
			//int play user levels button
			var optionsButton:MovieClip = new OptionsButton();
			optionsButton.buttonMode = true;
			optionsButton.x = BUTTONS_X;
			optionsButton.y = OPTIONS_Y;
			optionsButton.addEventListener(MouseEvent.CLICK, onMouseClick);
			optionsButton.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			optionsButton.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addChild(optionsButton);
		}

		private function gotoGame(event:MouseEvent):void {
			Aeon.getMe().playLevelFile(LevelPage.TEST_LEVEL_FILE);
		}

		private function gotoEditor(evt:MouseEvent):void {
			Aeon.getMe().gotoEditorPage();
		}
		
		private function onMouseClick(evt:MouseEvent):void{
			var t:MovieClip = MovieClip(evt.target);
			buttonClick.x = t.x + SELECTOR_X;
			buttonClick.y = t.y + SELECTOR_Y;
			buttonClick.visible = true;
			buttonSelect.visible = false;
		}
		
		private function onMouseOver(evt:MouseEvent):void{
			var t:MovieClip = MovieClip(evt.target);
			buttonSelect.x = t.x + SELECTOR_X;
			buttonSelect.y = t.y + SELECTOR_Y;
			buttonSelect.visible = true;
			buttonClick.visible = false;
		}
		private function onMouseOut(evt:MouseEvent):void{
			buttonSelect.visible = false;
			buttonClick.visible = false;
		}
	}
}
