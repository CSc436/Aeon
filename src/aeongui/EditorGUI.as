package aeongui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.display.SimpleButton;
	public class EditorGUI extends Sprite
	{
			public function EditorGUI() {
				TextFieldExample();
				var button:CustomSimpleButton = new CustomSimpleButton();
				addChild(button);
			}
			private var label:TextField;
			private var labelText:String = "Hello world and welcome to the show.";
			
			public function TextFieldExample() {
				configureLabel();
				setLabel(labelText);
			}
			
			public function setLabel(str:String):void {
				label.text = str;
			}
			
			private function configureLabel():void {
				label = new TextField();
				label.autoSize = TextFieldAutoSize.LEFT;
				label.background = true;
				label.border = true;
				
				var format:TextFormat = new TextFormat();
				format.font = "Verdana";
				format.color = 0xFFFF00;
				format.size = 10;
				format.underline = true;
				
				label.defaultTextFormat = format;
				addChild(label);
			}

	}
}
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	
	class CustomSimpleButton extends SimpleButton {
		private var upColor:uint   = 0xFFCC00;
		private var overColor:uint = 0xCCFF00;
		private var downColor:uint = 0x00CCFF;
		private var size:uint      = 80;
		
		public function CustomSimpleButton() {
			downState      = new ButtonDisplayState(downColor, size);
			overState      = new ButtonDisplayState(overColor, size);
			upState        = new ButtonDisplayState(upColor, size);
			hitTestState   = new ButtonDisplayState(upColor, size); // changes button hitbox
			hitTestState.x = 0;
			hitTestState.y = hitTestState.x;
			useHandCursor  = true;
		}
	}
	
	class ButtonDisplayState extends Shape {
		private var bgColor:uint;
		private var size:uint;
		
		public function ButtonDisplayState(bgColor:uint, size:uint) {
			this.bgColor = bgColor;
			this.size    = size;
			draw();
		}
		
		private function draw():void {
			graphics.beginFill(bgColor);
			graphics.drawRect(0, 0, size, size);
			graphics.endFill();
		}
	}
