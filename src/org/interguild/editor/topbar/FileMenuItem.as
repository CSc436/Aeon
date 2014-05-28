package org.interguild.editor.topbar {

	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import org.interguild.components.DropdownMenuItem;

	public class FileMenuItem extends DropdownMenuItem {

		private static const BG_WIDTH:uint = 200;

		private static const PADDING_TOP:uint = 2;
		private static const PADDING_LEFT:uint = 10;
		private static const PADDING_RIGHT:uint = 10;

		private static const TEXT_FONT:String = "Arial";
		private static const TEXT_SIZE:uint = 13;
		private static const TEXT_COLOR:uint = 0x000000; //black
		private static const TEXT_COLOR_OVER:uint = 0xFFFFFF; //white

		private var leftText:TextField;
		private var rightText:TextField;
		private var normalFormat:TextFormat;
		private var overFormat:TextFormat;

		public function FileMenuItem(leftString:String, rightString:String, onClick:Function) {
			super(onClick);

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
			addChildAt(leftText, 1);

			//init right text
			rightText = new TextField();
			rightText.autoSize = TextFieldAutoSize.LEFT;
			rightText.selectable = false;
			rightText.text = rightString;
			rightText.setTextFormat(normalFormat);
			rightText.x = BG_WIDTH - PADDING_RIGHT - rightText.width;
			rightText.y = PADDING_TOP;
			addChildAt(rightText, 1);
		}

		protected override function onMouseOver(evt:MouseEvent):void {
			super.onMouseOver(evt);

			leftText.setTextFormat(overFormat);
			rightText.setTextFormat(overFormat);
		}

		protected override function onMouseOut(evt:MouseEvent):void {
			super.onMouseOut(evt);

			leftText.setTextFormat(normalFormat);
			rightText.setTextFormat(normalFormat);
		}
	}
}
