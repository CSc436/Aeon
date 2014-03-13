package org.interguild.editor {
	import fl.controls.Button;
	
	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	public class DropDownMenu extends Sprite {
		
		private var fileLabel:Button;
		private var editLabel:Button;
		
		private var openButton:Button;
		private var saveButton:Button;
		private var menuButton:Button;
		
		private var editButton1:Button;
		private var editButton2:Button;
		
		private var fileSprite:Sprite;
		private var editSprite:Sprite;
		
		private var maskGrid:Sprite;
		private var numColumns:int;
		private var numRows:int;
		
		private var currEditor:EditorPage;
		
		public function DropDownMenu(grid:Sprite,editPage:EditorPage):void {
			maskGrid = grid;
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
			fileSprite.addEventListener(MouseEvent.ROLL_OVER, rollOverListener1);
			fileSprite.addEventListener(MouseEvent.ROLL_OUT, rollOutListener1);
			
			editLabel = new Button();
			editLabel.x = 0;
			editLabel.y = 0;
			//TODO find a use for edit
			//			editSprite.addChild(editLabel);
			editLabel.label = "Edit";
			editSprite.addEventListener(MouseEvent.ROLL_OVER, rollOverListener2);
			editSprite.addEventListener(MouseEvent.ROLL_OUT, rollOutListener2);
			
		}
		
		public function rollOverListener2(event:MouseEvent):void {
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
		
		public function rollOutListener2(event:MouseEvent):void {
			editSprite.removeChild(editButton1);
			editSprite.removeChild(editButton2);
		}
		
		public function rollOverListener1(event:MouseEvent):void {
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
			//get the data
//			trace("textFile: \n"+data);
			var code:String = data;
			//parse the first line to get title name
			var eol:int = code.indexOf("\n");
			var title:String = code.substr(0, eol);
			trace("title: " + title);
			code = code.substr(eol + 1); // skip this line
			
			//parse second line to get length and width
			eol = code.indexOf("\n");
			var line:String = code.substr(0, eol);
			var ix:int = line.indexOf("x");
			var lvlWidth:Number = Number(line.substr(0, ix));
			var lvlHeight:Number = Number(line.substr(ix + 1));
			trace("width: " + lvlWidth + " height: " + lvlHeight);
			code = code.substr(eol + 1); // skip this line
			
			var levelRead:String = "";
			var lineno:int = 1;
			var len:int = lvlWidth * lvlHeight + lvlHeight - 1;
			for (var i:uint = 0; i < len; i++) {
				var curChar:String = code.charAt(i);
//				trace("i: "+i+" char: "+curChar);
				switch (curChar) {
					case "\n":
						lineno++;
					case "#": //Player spawn
					case "x": //Terrain
					case "w": //WoodCrate
					case " ": //space
					case "s": //SteelCrate
						levelRead = levelRead.concat(curChar);
						break;
					//Character not found those trolls
					default:
						trace("Unknown level code character: '" + curChar + "' at line " + lineno + " at char number " + i);
				}
            }
            trace("levelRead: \n" + levelRead);
			currEditor.setLevelSize(title, levelRead, lvlWidth, lvlHeight);
		}
		
		
		public function setColumns(col:int):void{
			this.numColumns = col;
		}
		
		public function setRows(row:int):void{
			this.numRows = row;
		}
		
		//Save whatever is in the grid
		private function saveGameListener(e:MouseEvent):void {
			var button:Button = Button(e.target);
			
			var file:FileReference = new FileReference();
			var i:int;
			var row:int;
			var col:int;
			var string:String = currEditor.title + "\n" + this.numColumns + "x" + this.numColumns + "\n";
			for (i = 0; i < maskGrid.numChildren; i++) {
				row = i/this.numColumns;
				col = i%this.numColumns;
				if (maskGrid.getChildAt(i) != null) {
					if (maskGrid.getChildAt(i).name.length == 1) {
						string += maskGrid.getChildAt(i).name;
					} else {
						string += " ";
					}
					if (col == numColumns-1) {
						string += "\n";
					}
				}
			}
			var titlename:String = currEditor.title.text;
			file.save(string, titlename + ".txt");
		}
		
		public function mainMenuListener(event:MouseEvent):void {
			//TODO Return to main menu
			//prompt to save data?
			this.removeChild(fileSprite);
			currEditor.deleteSelf();
		}
		
		
		public function rollOutListener1(event:MouseEvent):void {
			fileSprite.removeChild(openButton);
			fileSprite.removeChild(saveButton);
			fileSprite.removeChild(menuButton);
		}
	}
}
