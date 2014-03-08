package org.interguild.game.level {
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.interguild.Aeon;

	public class LevelStartScreen extends Sprite {
		
		//text vars
		private static const FONT:String = new LevelTitleFont().fontName;
		private static const SIZE:Number = 60;
		private static const COLOR:uint = 0xFFFFFF; // white
		private static const BOLD:Boolean = true;
		private static const LOADING_TEXT:String = "Loading: ";
		private static const LOADING_FILE:String = "Loading File...";
		
		//background vars
		private static const BG_COLOR:uint = 0; //black
		private static const BG_ALPHA:Number = 1; // 100%
		private static const PADDING:uint = 10;
		
		private var titleText:TextField;
		
		public function LevelStartScreen(title:String) {
			//init text
			var progressFormat:TextFormat = new TextFormat(FONT, SIZE, COLOR, BOLD);
			titleText = new TextField();
			titleText.embedFonts = true;
			titleText.selectable = false;
			titleText.antiAliasType = AntiAliasType.ADVANCED;
			titleText.defaultTextFormat = progressFormat;
			titleText.autoSize = TextFieldAutoSize.CENTER;
			titleText.text = title;
			titleText.x = Aeon.STAGE_WIDTH / 2 - titleText.width / 2;
			titleText.y = PADDING;
			addChild(titleText);
			
			//init bg
//			graphics.beginFill(BG_COLOR, BG_ALPHA);
//			graphics.drawRect(titleText.x - PADDING, 0, titleText.width + 2 * PADDING, titleText.height + 2 * PADDING);
//			graphics.endFill();
		}
	}
}
