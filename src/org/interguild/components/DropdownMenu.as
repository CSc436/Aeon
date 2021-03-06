package org.interguild.components {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.interguild.Aeon;
	import org.interguild.editor.EditorPage;

	/**
	 * The following UML is not ASdoc friendly:
	 *
	 * 		----------------     inherits from	  ======================
	 * 		| DropdownMenu | <------------------- [your class goes here]
	 * 		----------------					  ======================
	 * 				|
	 * 				|uses
	 * 				|
	 * 				V
	 * 		---------------------	 contains	-----------------------
	 * 		| DropdownMenuPopup | <>----------- | DropdownMenuElement |
	 * 		--------------------- 				-----------------------
	 * 														^
	 * 														|
	 * 										  inherits from |
	 * 														|
	 * 						---------------------------------
	 * 						|						  |
	 * 						|						  |
	 * 			--------------------		-----------------------
	 * 			| DropdownMenuItem |		| DropdownMenuDivider |
	 * 			--------------------		-----------------------
	 * 					^							^
	 * 					|							|
	 * 					| inherits from				| inherits from
	 * 					|							|
	 * 			=====================		======================
	 * 			[your class goes here]		[your class goes here]
	 * 			=====================		======================
	 *
	 * Treat the DropdownMenu classes as abstract classes. If you want
	 * to make your own menu, make classes that extend:
	 * 		-DropdownMenu
	 * 		-DropdownMenuItem
	 * 		-DropdownMenuDivider
	 *
	 * When extending DropdownMenu call the following functions in your constructor:
	 * 		initButton();
	 */
	public class DropdownMenu extends Sprite {

		private static const DEFAULT_BG_COLOR:uint = 0xFFFFFF;

		private var button:Sprite;
		private var buttonFace:DisplayObject;
		private var buttonOver:DisplayObject;

		protected var popup:DropdownMenuPopup;
		private var clickArea:Sprite;

		/**
		 * Treat this like an abstract class. Do not instantiate it directly.
		 */
		public function DropdownMenu(showOverlay:Boolean) {
			initClickArea(showOverlay);
			initPopup();
		}

		protected function get backgroundColor():uint {
			return DEFAULT_BG_COLOR;
		}

		protected function initButton(upState:DisplayObject, overState:DisplayObject):void {
			this.buttonFace = upState;
			this.buttonOver = overState;

			button = new Sprite();
			button.buttonMode = true;
			button.addEventListener(MouseEvent.MOUSE_OVER, buttonMouseOver, false, 0, true);
			button.addEventListener(MouseEvent.CLICK, toggleMenu, false, 0, true);
			addChild(button);

			button.addChild(buttonFace);
			buttonOver.visible = false;
			button.addChild(buttonOver);

			popup.x = button.x;
			popup.y = button.y + button.height;
		}

		private function initClickArea(showOverlay:Boolean):void {
			clickArea = new Sprite();
			var overlayAlpha:Number = 0;
			if(showOverlay)
				overlayAlpha = EditorPage.OVERLAY_ALPHA;
			clickArea.graphics.beginFill(0, overlayAlpha);
			clickArea.graphics.drawRect(0, 0, Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT);
			clickArea.graphics.endFill();

			clickArea.addEventListener(MouseEvent.CLICK, hidePopup, false, 0, true);

			clickArea.visible = false;
			addChild(clickArea);
		}

		public override function set x(n:Number):void {
			super.x = n;
			clickArea.x = -n;
			var p:DisplayObjectContainer = parent;
			while (p) {
				clickArea.x -= p.x;
				p = p.parent;
			}
		}

		public override function set y(n:Number):void {
			super.y = n;
			clickArea.y = -n;
			var p:DisplayObjectContainer = parent;
			while (p) {
				clickArea.y -= p.y;
				p = p.parent;
			}
		}

		private function initPopup():void {
			popup = new DropdownMenuPopup(backgroundColor);

			popup.addEventListener(MouseEvent.CLICK, hidePopup, true, 0, true);

			popup.visible = false;
			addChild(popup);
		}

		protected function addItem(i:DropdownMenuElement):void {
			popup.addItem(i);
		}

		public function toggleMenu(evt:MouseEvent = null):void {
			if (popup.visible) {
				hidePopup();
			} else {
				showPopup();
			}
		}

		/**
		 * When an external event happens that needs us to close the file menu
		 */
		public function hideMenu():void {
			if (popup.visible)
				hidePopup();
		}

		protected function showPopup():void {
			popup.visible = true;
			addChild(popup);
			clickArea.visible = true;
			if (parent) {
				parent.addChild(this);
			}
		}

		protected function hidePopup(evt:MouseEvent = null):void {
			popup.visible = false;
			clickArea.visible = false;
		}

		private function buttonMouseOver(evt:MouseEvent):void {
			button.addEventListener(MouseEvent.MOUSE_OUT, buttonMouseOut, false, 0, true);
			button.removeEventListener(MouseEvent.MOUSE_OVER, buttonMouseOver);
			buttonOver.visible = true;
			buttonFace.visible = false;
		}

		private function buttonMouseOut(evt:MouseEvent):void {
			button.addEventListener(MouseEvent.MOUSE_OVER, buttonMouseOver, false, 0, true);
			button.removeEventListener(MouseEvent.MOUSE_OUT, buttonMouseOut);
			buttonFace.visible = true;
			buttonOver.visible = false;
		}
	}
}
