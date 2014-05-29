package org.interguild.editor.topbar {
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	import org.interguild.components.DropdownMenu;
	import org.interguild.components.DropdownMenuDivider;
	import org.interguild.editor.EditorPage;

	public class FileMenu extends DropdownMenu {

		private static const POSITION_X:uint = 10;
		private static const POSITION_Y:uint = 8;

		private static const BG_COLOR:uint = 0xcecece;

		private var editor:EditorPage;

		public function FileMenu(editor:EditorPage) {
			super();
			this.editor = editor;
			this.x = POSITION_X;
			this.y = POSITION_Y;

			initButton(new Bitmap(new FileButtonSprite()), new Bitmap(new FileMouseOverSprite()));

			addItem(new FileMenuItem("New Level", "Ctrl+N", function(evt:MouseEvent):void {
				editor.newLevel();
			}));
			addItem(new FileMenuItem("Open from File", "Ctrl+O", function(evt:MouseEvent):void {
				editor.openFromFile();
			}));
			addItem(new FileMenuItem("Save to File", "Ctrl+S", function(evt:MouseEvent):void {
				editor.saveToFile();
			}));
			addItem(new FileMenuItem("Save As...", "Ctrl+Shift+S", function(evt:MouseEvent):void {
				trace("SAVE AS...");
			}));

			addItem(new DropdownMenuDivider());

			addItem(new FileMenuItem("Close Level", "", function(evt:MouseEvent):void {
				editor.closeLevel();
			}));
			addItem(new FileMenuItem("Close All", "", function(evt:MouseEvent):void {
				editor.closeAllLevels();
			}));

			addItem(new DropdownMenuDivider());

			addItem(new FileMenuItem("Copy", "Ctrl+C", function(evt:MouseEvent):void {
				editor.copy();
			}));
			addItem(new FileMenuItem("Cut", "Ctrl+X", function(evt:MouseEvent):void {
				editor.cut();
			}));
			addItem(new FileMenuItem("Paste", "Ctrl+V", function(evt:MouseEvent):void {
				editor.paste();
			}));

			addItem(new DropdownMenuDivider());

			addItem(new FileMenuItem("Select All", "Ctrl+A", function(evt:MouseEvent):void {
				editor.selectAll();
			}));
			addItem(new FileMenuItem("Deselect", "Ctrl+D", function(evt:MouseEvent):void {
				editor.deselect();
			}));

			addItem(new DropdownMenuDivider());

//			addItem(new FileMenuItem("Zoom In", "Ctrl++", function(evt:MouseEvent):void {
//				editor.zoomIn();
//			}));
//			addItem(new FileMenuItem("Zoom Out", "Ctrl+-", function(evt:MouseEvent):void {
//				editor.zoomOut();
//			}));
			addItem(new FileMenuItem("Exit to Main Menu", "", function(evt:MouseEvent):void {
				editor.gotoMainMenu();
			}));
		}

		protected override function get backgroundColor():uint {
			return BG_COLOR;
		}
	}
}
