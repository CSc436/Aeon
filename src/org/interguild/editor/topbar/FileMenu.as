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
		
		private function initFileButton():void{
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
		
		private function initMenuItems():void{
			popup = new FileMenuPopup();
			popup.x = button.x;
			popup.y = button.y + button.height;
			
			popup.addItem(new FileMenuItem("New Level", "Ctrl+N", clickNew));
			popup.addItem(new FileMenuItem("Open", "Ctrl+O", clickOpen));
			popup.addItem(new FileMenuItem("Save", "Ctrl+S", clickSave));
			popup.addItem(new FileMenuItem("Save As...", "Ctrl+Shift+S", clickSaveAs));
			popup.addItem(new FileMenuItem("Close Level", "", clickClose));
			popup.addItem(new FileMenuItem("Close All", "", clickCloseAll));
			popup.addItem(new FileMenuItem("Copy", "Ctrl+C", clickCopy));
			popup.addItem(new FileMenuItem("Cut", "Ctrl+X", clickCut));
			popup.addItem(new FileMenuItem("Paste", "Ctrl+V", clickPaste));
			popup.addItem(new FileMenuItem("Deselect", "Ctrl+D", clickDeselect));
			popup.addItem(new FileMenuItem("Exit to Main Menu", "", clickExit));
			
			popup.addEventListener(MouseEvent.CLICK, hidePopup, true, 0, true);
			
			popup.visible = false;
			addChild(popup);
		}
		
		private function initClickArea():void{
			clickArea = new Sprite();
			clickArea.graphics.beginFill(0, 0);
			clickArea.graphics.drawRect(0, 0, Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT);
			clickArea.graphics.endFill();
			
			clickArea.addEventListener(MouseEvent.CLICK, hidePopup, false, 0, true);
			
			clickArea.visible = false;
			addChild(clickArea);
		}

		/**
		 * 
		 * @param evt
		 */
		public function toggleMenu(evt:MouseEvent = null):void {
			if(popup.visible){
				hidePopup();
			}else{
				showPopup();
			}
		}
		
		/**
		 * 
		 */
		public function hideMenu():void{
			if(popup.visible)
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
		
		private function showPopup():void{
			popup.visible = true;
			clickArea.visible = true;
		}
		
		private function hidePopup(evt:MouseEvent = null):void{
			popup.visible = false;
			clickArea.visible = false;
		}
		
		private function clickNew(evt:MouseEvent):void{
			editor.newLevel();
		}
		
		private function clickOpen(evt:MouseEvent):void{
			editor.openFromFile();
		}
		
		private function clickSave(evt:MouseEvent):void{
			editor.saveToFile();
		}
		
		private function clickSaveAs(evt:MouseEvent):void{
			trace("SAVE AS...");
		}
		
		private function clickClose(evt:MouseEvent):void{
			editor.closeLevel();
		}
		
		private function clickCloseAll(evt:MouseEvent):void{
			editor.closeAllLevels();
		}
		
		private function clickCopy(evt:MouseEvent):void{
			editor.copy();
		}
		
		private function clickCut(evt:MouseEvent):void{
			editor.cut();
		}
		
		private function clickPaste(evt:MouseEvent):void{
			editor.paste();
		}
		
		private function clickDeselect(evt:MouseEvent):void{
			editor.deselect();
		}
		
		private function clickExit(evt:MouseEvent):void{
			editor.gotoMainMenu();
		}
	}
}
