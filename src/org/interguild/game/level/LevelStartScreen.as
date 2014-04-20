package org.interguild.game.level {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.interguild.Aeon;
	import org.interguild.KeyMan;

	public class LevelStartScreen extends Sprite {

		//preview vars
		private static const PREVIEW_PADDING_X:uint = 50;

		//text vars
		private static const TITLE_FONT:String = new LevelTitleFont().fontName;
		private static const TITLE_SIZE:Number = 60;
		private static const TITLE_COLOR:uint = 0xFFFFFF; // white
		private static const TITLE_BOLD:Boolean = true;

		//jump-to-start vars
		private static const JUMP_FONT:String = new LevelTitleFont().fontName;
		private static const JUMP_SIZE:Number = 40;
		private static const JUMP_COLOR:uint = 0xFFFFFF; // white
		private static const JUMP_BOLD:Boolean = false;

		//text strings
		private static const LOADING_TEXT:String = "Loading: ";
		private static const LOADING_FILE:String = "Loading File...";
		private static const HOW_TO_START:String = "Press Jump to Start";

		//background vars
		private static const BG_COLOR:uint = 0; //black
		private static const BG_ALPHA:Number = 1; // 100%
		private static const PADDING:uint = 10;

		private var titleText:TextField;
		private var jumpToStart:Sprite;
		private var jumpText:TextField;

		// Buttons for the pause menu
		private var buttonContainer:Sprite;
		private var resumeButton:MovieClip;
		//private var restartCheckpointButton:Button;
		private var restartGameButton:MovieClip;
		private var editorButton:MovieClip;
		private var quitButton:MovieClip;

		public function LevelStartScreen(title:String) {
			initTitle(title);
			initJumpToStart();

			//init bg
//			graphics.beginFill(BG_COLOR, BG_ALPHA);
//			graphics.drawRect(titleText.x - PADDING, 0, titleText.width + 2 * PADDING, titleText.height + 2 * PADDING);
//			graphics.endFill();
		}

		private function initTitle(title:String):void {
			var h:Number;
			var progressFormat:TextFormat = new TextFormat(TITLE_FONT, TITLE_SIZE, TITLE_COLOR, TITLE_BOLD);
			progressFormat.align = TextFormatAlign.CENTER;
			titleText = new TextField();
			titleText.embedFonts = true;
			titleText.selectable = false;
			titleText.multiline = true;
			titleText.wordWrap = true;
			titleText.antiAliasType = AntiAliasType.ADVANCED;
			titleText.defaultTextFormat = progressFormat;
			titleText.text = title;
			titleText.autoSize = TextFieldAutoSize.CENTER;
			titleText.width = Aeon.STAGE_WIDTH;
			h = titleText.height + 10;
			titleText.autoSize = TextFieldAutoSize.NONE;
			titleText.height = h;
			titleText.x = Aeon.STAGE_WIDTH / 2 - titleText.width / 2;
			titleText.y = 0;
			addChild(titleText);
		}

		private function initJumpToStart():void {
			var w:Number;
			var h:Number;
			jumpToStart = new Sprite();
			var jumpFormat:TextFormat = new TextFormat(JUMP_FONT, JUMP_SIZE, JUMP_COLOR, JUMP_BOLD);
			jumpFormat.align = TextFormatAlign.CENTER;
			jumpText = new TextField();
			jumpText.embedFonts = true;
			jumpText.selectable = false;
			jumpText.antiAliasType = AntiAliasType.ADVANCED;
			jumpText.defaultTextFormat = jumpFormat;
			jumpText.autoSize = TextFieldAutoSize.CENTER;
			jumpText.text = HOW_TO_START;
			w = jumpText.width + 10;
			h = jumpText.height + 10;
			jumpText.autoSize = TextFieldAutoSize.NONE;
			jumpText.width = w;
			jumpText.height = h;
			jumpText.x = Aeon.STAGE_WIDTH / 2 - jumpText.width / 2;
			jumpText.y = Aeon.STAGE_HEIGHT - jumpText.height;
			jumpToStart.addChild(jumpText);
			addChild(jumpToStart);
		}

		public function initButtons():void {

			buttonContainer = new Sprite();
			buttonContainer.graphics.beginFill(0xC0C0C0, 0.75);
			buttonContainer.graphics.drawRoundRect(Aeon.STAGE_WIDTH / 2 - 100, 100, 200, 350, 10);
			buttonContainer.graphics.endFill();

			// Make button for resuming the game
			resumeButton = new ResumeButton();
			resumeButton.buttonMode = true;
			resumeButton.x = Aeon.STAGE_WIDTH / 2 - 50;
			resumeButton.y = 175;
			resumeButton.addEventListener(MouseEvent.CLICK, resumeGame);
			buttonContainer.addChild(resumeButton);

			// Make button for restarting from a checkpoint
//			restartCheckpointButton = new Button();
//			restartCheckpointButton.label = "Restart from Checkpoint";
//			restartCheckpointButton.x = 350;
//			restartCheckpointButton.y = 175;
//			restartCheckpointButton.height = 25;
//			restartCheckpointButton.width = 150;
//			// Make this work once we actually have checkpoints in the game
//			//restartCheckpointButton.addEventListener(MouseEvent.CLICK, restartFromCheckpoint);
//			this.parent.addChild(restartCheckpointButton);

			// Make button for restarting from the beginning of a level
			restartGameButton = new RestartButton();
			restartGameButton.buttonMode = true;
			restartGameButton.x = Aeon.STAGE_WIDTH / 2 - 50;
			restartGameButton.y = 225;
			restartGameButton.addEventListener(MouseEvent.CLICK, restartFromBeginning);
			buttonContainer.addChild(restartGameButton);

			// Make button for going to the level editor
			editorButton = new LevelEditorButton();
			editorButton.buttonMode = true;
			editorButton.x = Aeon.STAGE_WIDTH / 2 - 50;
			editorButton.y = 275;
			editorButton.addEventListener(MouseEvent.CLICK, goToEditor);
			buttonContainer.addChild(editorButton);

			// Make button for quitting the game
			quitButton = new QuitButton();
			quitButton.buttonMode = true;
			quitButton.x = Aeon.STAGE_WIDTH / 2 - 50;
			quitButton.y = 325;
			quitButton.addEventListener(MouseEvent.CLICK, quitGame);
			buttonContainer.addChild(quitButton);

			this.parent.addChild(buttonContainer)
		}

		protected function quitGame(event:MouseEvent):void {
			KeyMan.getMe().resetEscKey();
			Aeon.getMe().gotoMainMenu();
		}

		protected function goToEditor(event:MouseEvent):void {
			KeyMan.getMe().resetEscKey();
			// Probably want to give the user some kind of dialog warning them
			// that exiting to the editor will cause them to lose their progress
			// in the current level
			Aeon.getMe().gotoEditorPage();
		}

		protected function restartFromBeginning(event:MouseEvent):void {
			this.stage.focus = stage;
			KeyMan.getMe().resetEscKey();
			// This is hardcoded right now, but we probably want some kind of
			// global reference to the current file so that we know what level
			// needs to be restarted
			CONFIG::DEPLOY {
				Aeon.getMe().playLevelCode(TestLevel.getCode());
			}
			CONFIG::NODEPLOY {
				Aeon.getMe().playLevelFile(LevelPage.TEST_LEVEL_FILE);
			}

		}

		protected function resumeGame(event:MouseEvent):void {
			KeyMan.getMe().resumeFromButton();
		}

		public function showButtons():void {
			buttonContainer.visible = true;
		}

		public function hideButtons():void {
			buttonContainer.visible = false;
		}

		public function setJumpText(str:String):void {
			jumpText.text = str;
		}

		public function loadComplete():void {
			jumpToStart.visible = true;
		}

		public function getPreviewRegion():Rectangle {
			var rect:Rectangle = new Rectangle(PREVIEW_PADDING_X, titleText.y + titleText.height, Aeon.STAGE_WIDTH - PREVIEW_PADDING_X * 2, Aeon.STAGE_HEIGHT - titleText.y - titleText.height - jumpToStart.height);
			return rect;
		}
	}
}
