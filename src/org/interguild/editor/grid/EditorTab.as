package org.interguild.editor.grid {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import org.interguild.editor.tabs.EditorTabContainer;

	public class EditorTab extends Sprite {

		private static const CLOSE_BUTTON_X:uint = 113;
		private static const CLOSE_BUTTON_Y:uint = 7;

		private static const FONT_COLOR:uint = 0x000000;
		private static const FONT_SIZE:uint = 15;
		private static const FONT_FAMILY:String = "Arial";
		private static const FONT_X:uint = 10;
		private static const FONT_Y:uint = 5;
		private static const FONT_WIDTH:uint = 102;
		private static const FONT_HEIGHT:uint = 22;

		private var activeBG:Bitmap;
		private var inactiveBG:Bitmap;
		private var isActive:Boolean;

		private var closeNormal:Bitmap;
		private var closeOver:Bitmap;
		private var closeButton:Sprite;

		private var tabMan:EditorTabManager
		private var myLevel:EditorLevel;

		public function EditorTab(level:EditorLevel, tabMan:EditorTabManager) {
			this.myLevel = level;

			//init main tab color
			activeBG = new Bitmap(new TabActiveSprite());
			activeBG.visible = false;
			addChild(activeBG);
			this.tabMan = tabMan;

			//init inactive tab color
			inactiveBG = new Bitmap(new TabInactiveSprite());
			addChild(inactiveBG);

			//init title
			var format:TextFormat = new TextFormat(FONT_FAMILY, FONT_SIZE, FONT_COLOR);
			var title:TextField = new TextField();
			title.defaultTextFormat = format;
			title.x = FONT_X;
			title.y = FONT_Y;
			title.width = FONT_WIDTH;
			title.height = FONT_HEIGHT;
			title.text = "Untitled";
			title.selectable = false;
			title.mouseEnabled = false;
			addChild(title);

			//init close button
			closeButton = new Sprite();
			closeButton.x = CLOSE_BUTTON_X;
			closeButton.y = CLOSE_BUTTON_Y;
			closeButton.mouseChildren = false;
			closeButton.addEventListener(MouseEvent.MOUSE_OVER, onCloseOver, false, 0, true);
			closeButton.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
			addChild(closeButton);

			//init default close button
			closeNormal = new Bitmap(new TabCloseButtonSprite());
			closeButton.addChild(closeNormal);

			//init rollover close button
			closeOver = new Bitmap(new TabCloseOverSprite());
			closeOver.visible = false;
			closeButton.addChild(closeOver);

			addEventListener(MouseEvent.MOUSE_OVER, onTabOver, false, 0, true);
		}

		private function onTabOver(evt:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OVER, onTabOver);
			addEventListener(MouseEvent.MOUSE_OUT, onTabOut, false, 0, true);

			if (!isActive) {
				closeButton.visible = true;
			}
		}

		private function onTabOut(evt:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OUT, onTabOut);
			addEventListener(MouseEvent.MOUSE_OVER, onTabOver, false, 0, true);
			if (!isActive) {
				closeButton.visible = false;
			}
		}

		private function onCloseOver(evt:MouseEvent):void {
			closeButton.removeEventListener(MouseEvent.MOUSE_OVER, onCloseOver);
			closeButton.addEventListener(MouseEvent.MOUSE_OUT, onCloseOut, false, 0, true);
			closeOver.visible = true;
			closeNormal.visible = false;
		}

		private function onCloseOut(evt:MouseEvent):void {
			closeButton.addEventListener(MouseEvent.MOUSE_OVER, onCloseOver, false, 0, true);
			closeNormal.visible = true;
			closeOver.visible = false;
		}

		private function onCloseClick(evt:MouseEvent):void {
			evt.stopPropagation();
			//this function removes the button of interest
			//tabContainer.removeTab(tNum);
		}

		public function get level():EditorLevel {
			return myLevel;
		}

		public function activate():void {
			isActive = true;
			activeBG.visible = true;
			inactiveBG.visible = false;
			closeButton.visible = true;
		}

		public function deactivate():void {
			isActive = false;
			activeBG.visible = false;
			inactiveBG.visible = true;
			closeButton.visible = false;
		}
	}

}
