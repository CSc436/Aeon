package org.interguild.editor {
	import fl.controls.Button;

	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.net.FileReference;

	public class DropDownMenu extends Sprite {

		private var fileLabel:Button;
//		private var editLabel:Button;

		private var openButton:Button;
		private var saveButton:Button;
		private var menuButton:Button;

		private var editButton1:Button;
		private var editButton2:Button;

		private var fileSprite:Sprite;
		private var editSprite:Sprite;

		private var numColumns:int;
		private var numRows:int;

		private var currEditor:EditorPage;

		//constructor
		public function DropDownMenu(editPage:EditorPage):void {
			currEditor = editPage;
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
			fileSprite.addEventListener(MouseEvent.ROLL_OVER, fileRollOverListener);
			fileSprite.addEventListener(MouseEvent.ROLL_OUT, fileRollOutListener);

//			editLabel = new Button();
//			editLabel.x = 0;
//			editLabel.y = 0;
//			editLabel.label = "Edit";
//			editSprite.addEventListener(MouseEvent.ROLL_OVER, rollOverListener2);
//			editSprite.addEventListener(MouseEvent.ROLL_OUT, rollOutListener2);
			//TODO find a use for edit
			//editSprite.addChild(editLabel);
		}

//		public function rollOverListener2(event:MouseEvent):void {
//			editButton1 = new Button();
//			editButton1.x = 0;
//			editButton1.y = 20;
//			editButton1.label = "Dummy button";
//			editSprite.addChild(editButton1);
//
//			editButton2 = new Button();
//			editButton2.x = 0;
//			editButton2.y = 40;
//			editButton2.label = "Other button";
//			editSprite.addChild(editButton2);
//		}
//
//		public function rollOutListener2(event:MouseEvent):void {
//			editSprite.removeChild(editButton1);
//			editSprite.removeChild(editButton2);
//		}

		/**
		 * listener for file dropDown
		 */
		public function fileRollOverListener(event:MouseEvent):void {
			openButton = new Button();
			openButton.x = 0;
			openButton.y = 20;
			openButton.label = "Open";
			fileSprite.addChild(openButton);
			openButton.addEventListener(MouseEvent.CLICK, openGameListener);

			saveButton = new Button();
			saveButton.x = 0;
			saveButton.y = 40;
			saveButton.label = "Save";
			fileSprite.addChild(saveButton);
			saveButton.addEventListener(MouseEvent.CLICK, saveGameListener);

			menuButton = new Button();
			menuButton.x = 0;
			menuButton.y = 60;
			menuButton.label = "Main Menu";
			fileSprite.addChild(menuButton);
			menuButton.addEventListener(MouseEvent.CLICK, mainMenuListener);
		}

		private var filereader:FileReference;
		/**
		 * listener for open Button
		 */
		public function openGameListener(event:MouseEvent):void {
			//open the game
			filereader = new FileReference();
			filereader.addEventListener(Event.SELECT, selectHandler);
			filereader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			filereader.browse(); // ask user for file
		}

		private function selectHandler(event:Event):void {
			filereader.removeEventListener(Event.SELECT, selectHandler);
			filereader.load();
		}

		private function loadCompleteHandler(event:Event):void {
			filereader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			onFileLoad((String(filereader.data)).split("\r").join(""));
		}

		//data from file and length
		public function onFileLoad(data:String):void {
			currEditor.openLevel(data);
		}

		/**
		 * listener for save button
		 * Grabs the current data code to save from the editorPage
		 */
		private function saveGameListener(e:MouseEvent):void {
			var button:Button = Button(e.target);

			var file:FileReference = new FileReference();

			var levelcode:String = currEditor.getLevelCode();
			
			file.save(levelcode, levelcode.substring(0,levelcode.indexOf("\n")) + ".txt");
//			file.save(levelcode, levelcode+ ".txt");
		}

		/**
		 * main menu Button
		 * return to the main menu and forget the current menu
		 */
		public function mainMenuListener(event:MouseEvent):void {
			//TODO prompt to save data
			currEditor.gotoMainMenu();
		}

		/**
		 * when the cursor moves out of the drop down menu remove all
		 * the buttons that went with the dropdown menu
		 */
		public function fileRollOutListener(event:MouseEvent):void {
			fileSprite.removeChild(openButton);
			fileSprite.removeChild(saveButton);
			fileSprite.removeChild(menuButton);
		}
	}
}
