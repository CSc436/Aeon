package org.interguild.editor.dropdown {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.interguild.Aeon;
	import org.interguild.editor.EditorPage;

	public class FileMenu extends Sprite {

		private static const POSITION_X:uint = 10;
		private static const POSITION_Y:uint = 8;

		private var button:Sprite;
		private var buttonFace:Bitmap;
		private var buttonOver:Bitmap;
		
		private var popup:FileMenuPopup;
		private var clickArea:Sprite;
		
		private var editor:EditorPage;

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
			button.addEventListener(MouseEvent.CLICK, buttonMouseClick, false, 0, true);
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
			popup.addItem(new FileMenuItem("Copy", "Ctrl+C", clickCopy));
			popup.addItem(new FileMenuItem("Cut", "Ctrl+X", clickCut));
			popup.addItem(new FileMenuItem("Paste", "Ctrl+V", clickPaste));
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

		private function buttonMouseClick(evt:MouseEvent):void {
			if(popup.visible){
				hidePopup();
			}else{
				showPopup();
			}
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
			trace("NEW LEVEL");
		}
		
		private function clickOpen(evt:MouseEvent):void{
			editor.openFromFile();
		}
		
		private function clickSave(evt:MouseEvent):void{
			trace("SAVE LEVEL");
		}
		
		private function clickSaveAs(evt:MouseEvent):void{
			trace("SAVE AS...");
		}
		
		private function clickCopy(evt:MouseEvent):void{
			trace("COPY SELECTION");
		}
		
		private function clickCut(evt:MouseEvent):void{
			trace("CUT SELECTION");
		}
		
		private function clickPaste(evt:MouseEvent):void{
			trace("PASTE");
		}
		
		private function clickExit(evt:MouseEvent):void{
			editor.gotoMainMenu();
		}
	}
}
