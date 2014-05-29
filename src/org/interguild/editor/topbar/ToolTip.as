package org.interguild.editor.topbar {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ToolTip extends Sprite {

		private static const TEXT_FONT:String = "Arial";
		private static const TEXT_SIZE:Number = 13;
		private static const TEXT_COLOR:uint = 0xFFFFFF;

		private static const BG_COLOR:uint = 0x4b4b4b;

		private var checked:Boolean;

		public function ToolTip(parent:DisplayObjectContainer, text:String) {
			var textField:TextField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = new TextFormat(TEXT_FONT, TEXT_SIZE, TEXT_COLOR);
			textField.selectable = false;
			textField.text = text;
			textField.background = true;
			textField.backgroundColor = BG_COLOR;
			textField.x = 4;
			textField.y = 20;
			addChild(textField);

			this.visible = false;
			this.mouseEnabled = false;

			parent.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			parent.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}

		private function onOver(evt:MouseEvent):void {
			addEventListener(Event.ENTER_FRAME, onFrame);

			this.x = stage.mouseX;
			this.y = stage.mouseY;
			this.visible = true;
			stage.addChild(this); //move to top
		}

		private function onOut(evt:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, onFrame);

			this.visible = false;
		}

		private function onFrame(evt:Event):void {
			if (checked) {//update position at half the frame rate
				checked = false;
			} else {
				this.x = stage.mouseX;
				this.y = stage.mouseY;
				checked = true;
			}
		}
	}
}

