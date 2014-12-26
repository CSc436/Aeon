package org.interguild.game.gui {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Give this to LevelLoader so that it can display progress.
	 */
	public class LevelProgressBar extends Sprite {
		
		//text vars
		private static const FONT:String = "Arial";
		private static const SIZE:Number = 20;
		private static const COLOR:uint = 0xCCCCCC; // light gray
		private static const BOLD:Boolean = true;
		private static const LOADING_TEXT:String = "Loading: ";
		private static const LOADING_FILE:String = "Loading File...";
		
		//background vars
		private static const BG_COLOR:uint = 0; // black
		private static const BG_ALPHA:Number = 0.75; // 100%
		private static const PADDING:uint = 10;
		
		private var progressText:TextField;
		
		public function LevelProgressBar() {
			//init text
			var progressFormat:TextFormat = new TextFormat(FONT, SIZE, COLOR, BOLD);
			progressText = new TextField();
			progressText.defaultTextFormat = progressFormat;
			progressText.autoSize = TextFieldAutoSize.LEFT;
			progressText.text = LOADING_TEXT + "00%"; //two digits for measuring size
			progressText.x = PADDING;
			progressText.y = PADDING;
			addChild(progressText);
			
			//init bg
			graphics.beginFill(BG_COLOR, BG_ALPHA);
			graphics.drawRect(0, 0, progressText.width + 2 * PADDING, progressText.height + 2 * PADDING);
			graphics.endFill();
			
			progressText.text = LOADING_FILE;
		}
		
		public function setProgress(percent:Number):void{
			percent *= 100;
			progressText.text = LOADING_TEXT + Math.round(percent) + "%";
		}
		
		public function setError(text:String):void{
			progressText.text = text;
		}
	}
}
