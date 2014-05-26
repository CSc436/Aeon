package org.interguild.menu {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class FancyButton extends Sprite {
		
		private var up:DisplayObject;
		private var over:DisplayObject;
		private var hit:Sprite;
		
		/**
		 * Allows you to create a button with a custom click region
		 */
		public function FancyButton(upState:DisplayObject, overState:DisplayObject, hitRegion:Sprite) {
			up = upState;
			over = overState;
			over.visible = false;
			hit = hitRegion;
			hit.buttonMode = true;
			
			addChild(up);
			addChild(over);
			addChild(hitRegion);
			
			hit.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
		}
		
		private function onOver(evt:MouseEvent):void{
			hit.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			hit.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			up.visible = false;
			over.visible = true;
		}
		
		private function onOut(evt:MouseEvent):void{
			hit.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			hit.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
			over.visible = false;
			up.visible = true;
		}
	}
}
