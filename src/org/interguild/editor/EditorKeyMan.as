package org.interguild.editor {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class EditorKeyMan {

		private var editor:EditorPage;
		private var isDown:Array = new Array();
		private var stage:Stage;

		public function EditorKeyMan(editor:EditorPage, stage:Stage) {
			this.editor = editor;
			this.stage = stage;
			activate();
		}

		public function activate():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		public function deactivate():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onKeyDown(evt:KeyboardEvent):void {
			var isNotDown:Boolean = isDown[evt.keyCode] == null;
			if (evt.ctrlKey) {
				switch (evt.keyCode) {
					case 78: //CTRL + N
						if (isNotDown)
							editor.newLevel();
						break;
					case 79: //CTRL + O
						if (isNotDown)
							editor.openFromFile();
						break;
					case 83: //CTRL + S
						if (isNotDown)
							editor.saveToFile();
						break;
					case 89: //CTRL + Y
						if (isNotDown)
							editor.redo();
						break;
					case 90: //CTRL + Z
						if (isNotDown)
							editor.undo();
						break;
					case 67: //CTRL + C
						if (isNotDown)
							editor.copy();
						break;
					case 88: //CTRL + X
						if (isNotDown)
							editor.cut();
						break;
					case 86: //CTRL + V
						if (isNotDown)
							editor.paste();
						break;
					case 68: //CTRL + D
						editor.deselect();
						break;
					case 13: //CTRL + ENTER
						editor.playLevel();
						break;
					case 189: //CTROL + -
						editor.zoomOut();
						break;
					case 187:
						editor.zoomIn();
						break;
					default:
						trace(evt.keyCode);
						break;
				}
			} else {
				switch (evt.keyCode) {
					case 8:
					case 46: //ctrl backspace or ctrl delete
						if (isNotDown)
							editor.deleteSelection();
						break;
					case 27: //Esc key
						if (isNotDown)
							editor.toggleMenu();
						break;
					case 32: //spacebar
						if(isNotDown)
							editor.handToolEnabled = true;
						break;
				}
			}
			isDown[evt.keyCode] = true;
		}

		private function onKeyUp(evt:KeyboardEvent):void {
			isDown[evt.keyCode] = null;
			if(evt.keyCode == 32) //spacebar
				editor.handToolEnabled = false;
		}
	}
}

