package org.interguild.editor.topbar {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FileMenuItem extends Sprite {
		
		private static const TEXT_FONT:String = "Arial";
		private static const TEXT_SIZE:uint = 13;
		private static const TEXT_COLOR:uint = 0x000000; //black
		private static const TEXT_COLOR_OVER:uint = 0xFFFFFF; //white
		
		private static const PADDING_TOP:uint = 2;
		private static const PADDING_LEFT:uint = 10;
		private static const PADDING_RIGHT:uint = 10;
		
		private static const BG_HEIGHT:uint = 25;
		private static const BG_WIDTH:uint = 200;
		private static const BG_COLOR_OVER:uint = 0x115867; //teal
		
		private var leftText:TextField;
		private var rightText:TextField;
		
		private var normalFormat:TextFormat;
		private var overFormat:TextFormat;
		
		private var clickArea:Sprite;
		private var rolloverBG:Sprite;
		
		public function FileMenuItem(leftString:String, rightString:String, onClick:Function) {
			//init bg
			rolloverBG = new Sprite();
			rolloverBG.graphics.beginFill(BG_COLOR_OVER);
			rolloverBG.graphics.drawRect(0, 0, BG_WIDTH, BG_HEIGHT);
			rolloverBG.graphics.endFill();
			rolloverBG.visible = false;
			addChild(rolloverBG);
			
			//init formats
			normalFormat = new TextFormat(TEXT_FONT, TEXT_SIZE, TEXT_COLOR);
			overFormat = new TextFormat(TEXT_FONT, TEXT_SIZE, TEXT_COLOR_OVER);
			
			//init left text
			leftText = new TextField();
			leftText.autoSize = TextFieldAutoSize.LEFT;
			leftText.selectable = false;
			leftText.text = leftString;
			leftText.setTextFormat(normalFormat);
			leftText.x = PADDING_LEFT;
			leftText.y = PADDING_TOP;
			addChild(leftText);
			
			//init right text
			rightText = new TextField();
			rightText.autoSize = TextFieldAutoSize.LEFT;
			rightText.selectable = false;
			rightText.text = rightString;
			rightText.setTextFormat(normalFormat);
			rightText.x = BG_WIDTH - PADDING_RIGHT - rightText.width;
			rightText.y = PADDING_TOP;
			addChild(rightText);
			
			//init clickable area
			clickArea = new Sprite();
			clickArea.graphics.beginFill(0, 0);
			clickArea.graphics.drawRect(0, 0, BG_WIDTH, BG_HEIGHT);
			clickArea.graphics.endFill();
			clickArea.buttonMode = true;
			addChild(clickArea);
			
			//init events
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.CLICK, onClick, true, 0, true);
		}
		
		private function onMouseOver(evt:MouseEvent):void{
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			
			leftText.setTextFormat(overFormat);
			rightText.setTextFormat(overFormat);
			rolloverBG.visible = true;
		}
		
		private function onMouseOut(evt:MouseEvent):void{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			
			leftText.setTextFormat(normalFormat);
			rightText.setTextFormat(normalFormat);
			rolloverBG.visible = false;
		}
	}
}
