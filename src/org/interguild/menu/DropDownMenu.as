package org.interguild.menu
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import fl.controls.Button;

	
	public class DropDownMenu extends Sprite {
		
		private var fileLabel:Button;
		
		private var testButton1:Button;
		private var testButton2:Button;
		private var sprite:Sprite;
		
		public function DropDownMenu(): void {
			sprite = new Sprite();
			addChild(sprite);
			
			fileLabel = new Button();
			fileLabel.x = 0;
			fileLabel.y = 0;
			sprite.addChild(fileLabel);
			fileLabel.label = "File";
			sprite.addEventListener(MouseEvent.ROLL_OVER, rollListener);
			sprite.addEventListener(MouseEvent.ROLL_OUT, rollListener2);
			
		}
		
		public function rollListener(event:MouseEvent): void {			
			testButton1 = new Button();
			testButton1.x = 0;
			testButton1.y = 20;
			testButton1.label = "Open";
			sprite.addChild(testButton1);
			
			testButton2 = new Button();
			testButton2.x = 0;
			testButton2.y = 40;
			testButton2.label = "Close";
			sprite.addChild(testButton2);
		}
		
		public function rollListener2(event:MouseEvent): void {
			sprite.removeChild(testButton1);
			sprite.removeChild(testButton2);
		}
		
		
	}
}