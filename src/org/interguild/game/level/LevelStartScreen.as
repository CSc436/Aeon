package org.interguild.game.level {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.interguild.Aeon;

	public class LevelStartScreen extends Sprite {
		
		//text vars
		private static const FONT:String = "Arial";
		private static const SIZE:Number = 18;
		private static const COLOR:uint = 0xCC0000; // dark red
		private static const BOLD:Boolean = true;
		private static const LOADING_TEXT:String = "Loading: ";
		private static const LOADING_FILE:String = "Loading File...";
		
		//background vars
		private static const BG_COLOR:uint = 0xFFFFFF; // white
		private static const BG_ALPHA:Number = 0.75; // 100%
		private static const PADDING:uint = 10;
		
		private var titleText:TextField;
		
		public function LevelStartScreen(title:String) {
			//init text
			var progressFormat:TextFormat = new TextFormat(FONT, SIZE, COLOR, BOLD);
			titleText = new TextField();
			titleText.defaultTextFormat = progressFormat;
			titleText.autoSize = TextFieldAutoSize.CENTER;
			titleText.text = title;
			titleText.x = Aeon.STAGE_WIDTH / 2;
			titleText.y = PADDING;
			addChild(titleText);
			
			//init bg
			graphics.beginFill(BG_COLOR, BG_ALPHA);
			graphics.drawRect(titleText.x - PADDING, 0, titleText.width + 2 * PADDING, titleText.height + 2 * PADDING);
			graphics.endFill();
		}
	}
}
