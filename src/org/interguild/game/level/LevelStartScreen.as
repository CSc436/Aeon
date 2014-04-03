package org.interguild.game.level {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import fl.controls.Button;
	
	import org.interguild.Aeon;

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
		private var resumeButton:Button;
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
			//var pauseMenu:Sprite = new Sprite();	
			
			resumeButton = new Button();
			resumeButton.label = "Resume";
			resumeButton.x = 350;
			resumeButton.y = 125;
			resumeButton.height = 25;
			resumeButton.width = 150;
			this.parent.addChild(resumeButton);
			
			quitButton = new Button();
			quitButton.label = "Quit Game";
			quitButton.x = 350;
			quitButton.y = 175;
			quitButton.height = 25;
			quitButton.width = 150;
			this.parent.addChild(quitButton);
			
//			pauseMenu.height = 300;
//			pauseMenu.width = 150;
//			pauseMenu.x = 350;
//			pauseMenu.y = 125;
//			pauseMenu.graphics.beginFill(345, BG_ALPHA);
//			pauseMenu.graphics.endFill();
//			addChild(pauseMenu);
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
