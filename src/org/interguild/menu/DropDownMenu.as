package org.interguild.menu
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;

	
	public class DropDownMenu extends Sprite {
		
		private var fileLabel:Button;
		private var editLabel:Button;
		
		private var fileButton1:Button;
		private var fileButton2:Button;
		private var editButton1:Button;
		private var editButton2:Button;
		
		private var fileSprite:Sprite;
		private var editSprite:Sprite;
		
		public function DropDownMenu(): void {
			fileSprite = new Sprite();
			addChild(fileSprite);
			
			editSprite = new Sprite();
			editSprite.x = 100;
			addChild(editSprite);
			
			fileLabel = new Button();
			fileLabel.x = 0;
			fileLabel.y = 0;
			fileSprite.addChild(fileLabel);
			fileLabel.label = "File";
			fileSprite.addEventListener(MouseEvent.ROLL_OVER, rollOverListener1);
			fileSprite.addEventListener(MouseEvent.ROLL_OUT, rollOutListener1);
			
			editLabel = new Button();
			editLabel.x = 0;
			editLabel.y = 0;
			editSprite.addChild(editLabel);
			editLabel.label = "Edit";
			editSprite.addEventListener(MouseEvent.ROLL_OVER, rollOverListener2);
			editSprite.addEventListener(MouseEvent.ROLL_OUT, rollOutListener2);
			
		}
		
		public function rollOverListener2(event:MouseEvent): void {
			editButton1 = new Button();
			editButton1.x = 0;
			editButton1.y = 20;
			editButton1.label = "Dummy button";
			editSprite.addChild(editButton1);
			
			editButton2 = new Button();
			editButton2.x = 0;
			editButton2.y = 40;
			editButton2.label = "Other button";
			editSprite.addChild(editButton2);
		}
		
		public function rollOutListener2(event:MouseEvent): void {
			editSprite.removeChild(editButton1);
			editSprite.removeChild(editButton2);
		}
		
		public function rollOverListener1(event:MouseEvent): void {			
			fileButton1 = new Button();
			fileButton1.x = 0;
			fileButton1.y = 20;
			fileButton1.label = "Open";
			fileSprite.addChild(fileButton1);
			
			fileButton2 = new Button();
			fileButton2.x = 0;
			fileButton2.y = 40;
			fileButton2.label = "Close";
			fileSprite.addChild(fileButton2);
		}
		
		public function rollOutListener1(event:MouseEvent): void {
			fileSprite.removeChild(fileButton1);
			fileSprite.removeChild(fileButton2);
		}
		
		
	}
}