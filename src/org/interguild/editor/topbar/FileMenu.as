package org.interguild.editor.topbar {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import org.interguild.Aeon;
	import org.interguild.editor.EditorPage;

	/**
	 *
	 * @author Livio
	 */
	public class FileMenu extends Sprite {

		private static const POSITION_X:uint = 10;
		private static const POSITION_Y:uint = 8;

		private var button:Sprite;
		private var buttonFace:Bitmap;
		private var buttonOver:Bitmap;

		private var popup:FileMenuPopup;
		private var clickArea:Sprite;

		private var editor:EditorPage;

		/**
		 *
		 * @param editor
		 */
		public function FileMenu(editor:EditorPage) {
			this.editor = editor;

			initClickArea();
			initFileButton();
			initMenuItems();
		}

		private function initFileButton():void {
			button = new Sprite();
			button.x = POSITION_X;
			button.y = POSITION_Y;
			button.buttonMode = true;
			button.addEventListener(MouseEvent.MOUSE_OVER, buttonMouseOver, false, 0, true);
			button.addEventListener(MouseEvent.CLICK, toggleMenu, false, 0, true);
			addChild(button);

			buttonFace = new Bitmap(new FileButtonSprite());
			button.addChild(buttonFace);

			buttonOver = new Bitmap(new FileMouseOverSprite());
			buttonOver.visible = false;
			button.addChild(buttonOver);
		}

		private function initMenuItems():void {
			popup = new FileMenuPopup();
			popup.x = button.x;
			popup.y = button.y + button.height;

			popup.addItem(new FileMenuItem("New Level", "Ctrl+N", function(evt:MouseEvent):void {
				editor.newLevel();
			}));
			popup.addItem(new FileMenuItem("Open", "Ctrl+O", function(evt:MouseEvent):void {
				editor.openFromFile();
			}));
			popup.addItem(new FileMenuItem("Save", "Ctrl+S", function(evt:MouseEvent):void {
				editor.saveToFile();
			}));
			popup.addItem(new FileMenuItem("Save As...", "Ctrl+Shift+S", function(evt:MouseEvent):void {
				trace("SAVE AS...");
			}));
			popup.addItem(new FileMenuItem("Close Level", "", function(evt:MouseEvent):void {
				editor.closeLevel();
			}));
			popup.addItem(new FileMenuItem("Close All", "", function(evt:MouseEvent):void {
				editor.closeAllLevels();
			}));
			popup.addItem(new FileMenuItem("Copy", "Ctrl+C", function(evt:MouseEvent):void {
				editor.copy();
			}));
			popup.addItem(new FileMenuItem("Cut", "Ctrl+X", function(evt:MouseEvent):void {
				editor.cut();
			}));
			popup.addItem(new FileMenuItem("Paste", "Ctrl+V", function(evt:MouseEvent):void {
				editor.paste();
			}));
			popup.addItem(new FileMenuItem("Deselect", "Ctrl+D", function(evt:MouseEvent):void {
				editor.deselect();
			}));
			popup.addItem(new FileMenuItem("Zoom In", "Ctrl++", function(evt:MouseEvent):void {
				editor.zoomIn();
			}));
			popup.addItem(new FileMenuItem("Zoom Out", "Ctrl+-", function(evt:MouseEvent):void {
				editor.zoomOut();
			}));
			popup.addItem(new FileMenuItem("Exit to Main Menu", "", function(evt:MouseEvent):void {
				editor.gotoMainMenu();
			}));

			popup.addEventListener(MouseEvent.CLICK, hidePopup, true, 0, true);

			popup.visible = false;
			addChild(popup);
		}

		private function initClickArea():void {
			clickArea = new Sprite();
			clickArea.graphics.beginFill(0, 0);
			clickArea.graphics.drawRect(0, 0, Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT);
			clickArea.graphics.endFill();

			clickArea.addEventListener(MouseEvent.CLICK, hidePopup, false, 0, true);

			clickArea.visible = false;
			addChild(clickArea);
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

		private function showPopup():void {
			popup.visible = true;
			clickArea.visible = true;
		}

		private function hidePopup(evt:MouseEvent = null):void {
			popup.visible = false;
			clickArea.visible = false;
		}
	}
}
