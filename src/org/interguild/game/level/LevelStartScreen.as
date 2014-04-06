package org.interguild.game.level {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import fl.controls.Button;
	
	import org.interguild.Aeon;
	import org.interguild.KeyMan;

	public class LevelStartScreen extends Sprite {

		//preview vars
		private static const PREVIEW_PADDING_X:uint = 50;

		//text vars
		private static const TITLE_FONT:String = new LevelTitleFont().fontName;
		private static const TITLE_SIZE:Number = 60;
		private static const TITLE_COLOR:uint = 0;//0xFFFFFF; // white
		private static const TITLE_BOLD:Boolean = true;

		//jump-to-start vars
		private static const JUMP_FONT:String = new LevelTitleFont().fontName;
		private static const JUMP_SIZE:Number = 40;
		private static const JUMP_COLOR:uint = 0;//0xFFFFFF; // white
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
		private var resumeButton:Button;
		private var restartCheckpointButton:Button;
		private var restartGameButton:Button;
		private var editorButton:Button;
		private var quitButton:Button;

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
			
			// Make button for resuming the game
			resumeButton = new Button();
			resumeButton.label = "Resume (Esc)";
			resumeButton.x = 350;
			resumeButton.y = 125;
			resumeButton.height = 25;
			resumeButton.width = 150;
			resumeButton.addEventListener(MouseEvent.CLICK, resumeGame);
			this.parent.addChild(resumeButton);
			
			// Make button for restarting from a checkpoint
			restartCheckpointButton = new Button();
			restartCheckpointButton.label = "Restart from Checkpoint";
			restartCheckpointButton.x = 350;
			restartCheckpointButton.y = 175;
			restartCheckpointButton.height = 25;
			restartCheckpointButton.width = 150;
			// Make this work once we actually have checkpoints in the game
			//restartCheckpointButton.addEventListener(MouseEvent.CLICK, restartFromCheckpoint);
			this.parent.addChild(restartCheckpointButton);
			
			// Make button for restarting from the beginning of a level
			restartGameButton = new Button();
			restartGameButton.label = "Restart from Beginning";
			restartGameButton.x = 350;
			restartGameButton.y = 225;
			restartGameButton.height = 25;
			restartGameButton.width = 150;
			restartGameButton.addEventListener(MouseEvent.CLICK, restartFromBeginning);
			this.parent.addChild(restartGameButton);
			
			// Make button for going to the level editor
			editorButton = new Button();
			editorButton.label = "Level Editor";
			editorButton.x = 350;
			editorButton.y = 275;
			editorButton.height = 25;
			editorButton.width = 150;
			editorButton.addEventListener(MouseEvent.CLICK, goToEditor);
			this.parent.addChild(editorButton);
			
			// Make button for quitting the game
			quitButton = new Button();
			quitButton.label = "Quit Game";
			quitButton.x = 350;
			quitButton.y = 325;
			quitButton.height = 25;
			quitButton.width = 150;
			quitButton.addEventListener(MouseEvent.CLICK, quitGame);
			this.parent.addChild(quitButton);
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
			KeyMan.getMe().resetEscKey();
			// This is hardcoded right now, but we probably want some kind of
			// global reference to the current file so that we know what level
			// needs to be restarted
			Aeon.getMe().playLevelFile(LevelPage.TEST_LEVEL_FILE);
		}
		
		protected function resumeGame(event:MouseEvent):void {
			KeyMan.getMe().resumeFromButton();
		}
		
		public function showButtons():void {
			resumeButton.visible = true;
			restartCheckpointButton.visible = true;
			restartGameButton.visible = true;
			editorButton.visible = true;
			quitButton.visible = true;
		}
		
		public function hideButtons():void {
			resumeButton.visible = false;
			restartCheckpointButton.visible = false;
			restartGameButton.visible = false;
			editorButton.visible = false;
			quitButton.visible = false;
		}
		
		public function setJumpText(str:String):void {
			jumpText.text = str;
		}

		public function loadComplete():void {
			jumpToStart.visible = true;
		}

		public function getPreviewRegion():Rectangle {
			var rect:Rectangle =  new Rectangle(PREVIEW_PADDING_X, titleText.y + titleText.height, Aeon.STAGE_WIDTH - PREVIEW_PADDING_X * 2, Aeon.STAGE_HEIGHT - titleText.y - titleText.height - jumpToStart.height);
			return rect;
		}
	}
}
