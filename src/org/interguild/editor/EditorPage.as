package org.interguild.editor {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	
	import org.interguild.Aeon;
	import org.interguild.editor.scrollBar.FullScreenScrollBar;
	import org.interguild.editor.scrollBar.HorizontalBar;
	import org.interguild.game.level.LevelLoader;
	import org.interguild.game.level.LevelPage;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Sprite {
		//Following is code to import images for everything
		[Embed(source = "../../../../images/testButton.png")] private var TestButton:Class;
		[Embed(source = "../../../../images/clearAllButton.png")] private var ClearButton:Class;
		[Embed(source = "../../../../images/wallButton.png")] private var WallButton:Class;
		[Embed(source = "../../../../images/woodButton.png")] private var WoodButton:Class;
		[Embed(source = "../../../../images/startButton.png")] private var StartButton:Class;
		[Embed(source = "../../../../images/resizeButton.png")] private var ResizeButton:Class;
		[Embed(source = "../../../../images/woodBox.png")] private var woodImg:Class;
		//TODO update picture
		[Embed(source = "../../../../images/wall.png")]
		private var wallImg:Class;
		//TODO update picture
		[Embed(source = "../../../../images/flag.jpg")]
		private var flagImg:Class;
		
		//following are objects on this sprite
		private var playerSpawnButton:Button;
		private var wallButton:Button;
		private var clearButton:Button;
		private var woodButton:Button;
		private var testButton:Button;
		private var resizeButton:Button;
		private var tf:TextArea;
		public  var title:TextInput;
		private  var widthBox:TextInput;
		private  var heightBox:TextInput;
		private var undoButton:Button;
		private var redoButton:Button;
		private var titlef:TextField;
		private var widthf:TextField;
		private var heightf:TextField;

		private var lvlloader:LevelLoader;
		private var gridContainer:Sprite;
		private var grid:Sprite;
		private var gridMask:Sprite;

		private var dropDown:DropDownMenu;

		private var mainMenu:Aeon;
		
		private var scrollBar:FullScreenScrollBar;
		private var scroll:HorizontalBar;
		// UNDO REDO ACTIONS ARRAYLIST
		private var undoList:Array;
		private var redoList:Array;
		//Following variables are toggles for when adding items to GUI
		private var isWall:Boolean = false;
		private var isWoodBox:Boolean = false;
		private var isSteelBox:Boolean = false;
		private var isStart:Boolean = false;

		private static var activeButton:int = 0;
		private static const air:int = 0;
		private static const wall:int = 1;
		private static const wood:int = 2;
		private static const steel:int = 3;
		private static const playerspawn:int = 4;
		
		//size of level
		private var levelColumns:int, levelRows:int;
		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage(mainMenu:Aeon):void {
			this.mainMenu = mainMenu;
			
			//playerstart button
			playerSpawnButton = makeButton("Start", StartButton, 750, 150);
			playerSpawnButton.addEventListener(MouseEvent.CLICK, startClick);
			
			//wallbutton
			wallButton = makeButton("Wall", WallButton, 750, 200);
			wallButton.addEventListener(MouseEvent.CLICK, wallClick);
			
			//woodbutton:
			woodButton = makeButton("Wood", WoodButton, 750, 250);
			woodButton.addEventListener(MouseEvent.CLICK, woodBoxClick);
			
			//clear button:
			clearButton = makeButton("Clear All", ClearButton, 750, 300);
			clearButton.addEventListener(MouseEvent.CLICK, clearClick);
			
			//Test button:
			testButton = makeButton("Test Game", TestButton, 350, 50);
			testButton.addEventListener(MouseEvent.CLICK, testGame);
			
			//change size button:
			resizeButton = makeButton("Resize", ResizeButton, 800, 50);
			resizeButton.addEventListener(MouseEvent.CLICK, resizeClick);
			undoList = new Array();
			redoList = new Array();
			
			//undo button:
			undoButton = new Button();
			undoButton.label = "Undo";
			undoButton.x = 750;
			undoButton.y = 350;
			undoButton.useHandCursor = true;
			undoButton.addEventListener(MouseEvent.CLICK, undoClick);
			
			//title text field
			titlef = new TextField();
			titlef.text = "Title:";
			titlef.x= 25;
			titlef.y = 50;
			//width text field
			widthf = new TextField();
			widthf.text = "Width:";
			widthf.x= 655;
			widthf.y = 15;
			//height text field
			heightf = new TextField();
			heightf.text = "Height:";
			heightf.x= 655;
			heightf.y = 40;
			//for entering a title name
			title = new TextInput();
			title.width = 250;
			title.height = 25;
			title.x = 55;
			title.y = 50;
			title.text = "Level Name";
			
			//for entering a width and height
			widthBox = new TextInput();
			widthBox.width = 50;
			widthBox.height = 25;
			widthBox.x = 700;
			widthBox.y = 15;
			heightBox = new TextInput();
			heightBox.width = 50;
			heightBox.height = 25;
			heightBox.x = 700;
			heightBox.y = 40;
			//textfield
			tf = new TextArea();
			tf.width = 200;
			tf.height = 400;
			tf.x = 700;
			tf.y = 100;
			tf.editable = false;

			grid = new Sprite();
			//add the drop down menu
			dropDown = new DropDownMenu(grid, this);
			dropDown.x = 5;
			dropDown.y = 5;

			//default this level size
			setColumns(15, 15);
			grid = makeBlank(25,25);
			
			gridMask = new Sprite();
			gridMask.graphics.beginFill(0);
			gridMask.graphics.drawRect(0,0,550,370);
			gridMask.graphics.endFill();
			gridMask.x = 20;
			gridMask.y = 100;
			grid.mask = gridMask;
			addChild(gridMask);
			
			
			// Arguments: Content to scroll, track color, grabber color, grabber press color, grip color, track thickness, grabber thickness, ease amount, whether grabber is “shiny"
			// Arguments: Content to scroll, track color, grabber color, grabber press color, grip color, track thickness, grabber thickness, ease amount, whether grabber is “shiny”
			scrollBar = new FullScreenScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			scrollBar.y = 100;
			addChild(scrollBar);
			scroll = new HorizontalBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(scroll);
			//grid.addChild(scrollBar);
			addChild(resizeButton);
			addChild(heightf);
			addChild(widthf);
			addChild(widthBox);
			addChild(heightBox);
			addChild(title);
			addChild(titlef);
			addChild(testButton);
			addChild(tf);
			addChild(wallButton);
			addChild(woodButton);
			addChild(playerSpawnButton);
			addChild(clearButton);
			addChild(grid);
			addChild(dropDown);
			addChild(undoButton);
			lvlloader = new LevelLoader();
			lvlloader.addLevelParsedListener(setLevelSize);
		}

		/**
		 * set size of the grid
		 */
		private function setColumns(r:int, c:int):void {
			levelRows = r;
			levelColumns = c;
			dropDown.setRows(r);
			dropDown.setColumns(c);
		}
		
		public function openLevel(data:String):void{
			lvlloader.parseLevelCode(data);
		}
		
		/**
		 * This function is given by the i/o buffer reader to create a new level
		 */
		public function setLevelSize(title:String, code:String, rows:int, columns:int):void{
			this.levelRows = rows;
			this.levelColumns = columns;
			this.title.text = title;
			
			var levelRead:String = "";
			var lineno:int = 1;
			var len:int = columns * rows + rows -1;
//			trace("title: " + title);
//			trace("width: " + lvlWidth + " height: " + lvlHeight);
//			trace("length of file "+len);
//			trace(code);
			var sprite:Sprite = this.makeBlank(rows, columns);
			for (var i:uint = 0; i < len; i++) {
				var curChar:String = code.charAt(i);
				sprite = Sprite(grid.getChildAt(i));
				switch (curChar) {
					case "\n":
						lineno++; levelRead = levelRead.concat(curChar); break;
					case "#": //Player spawn
						levelRead = levelRead.concat(curChar);
						sprite.name = "#"; sprite.addChild(new flagImg()); break;
					case "x": //Terrain
						levelRead = levelRead.concat(curChar);
						sprite.name = "x"; sprite.addChild(new wallImg()); break;
					case "w": //WoodCrate
						levelRead = levelRead.concat(curChar);
						sprite.name = "w"; sprite.addChild(new woodImg()); break;
					case " ": //space
						levelRead = levelRead.concat(curChar);
						sprite.name = " "; sprite.addChild(new Sprite()); break;
					case "s": //SteelCrate
						levelRead = levelRead.concat(curChar);
						sprite.name = "s"; sprite.addChild(new wallImg()); break;
					//Character not found those trolls
					default:
						trace("Unknown level code character: '" + curChar + "' at line " + lineno + " at char number " + i);
				}
			}
			
//			this.lvlloader.setLevel(levelRead, title, rows, columns);
		}
		
		/**
		 * Helps populate the sprite by setting up buttons
		 *
		 * @param   index
		 * @param   row
		 * @param   column
		 */
		private function makeButton(label:String, image:Class, xpixel:int, ypixel:int):Button {
			var b:Button = new Button();
			b.label = label;
			b.setStyle("icon", image);
			b.x = xpixel;
			b.y = ypixel;
			b.useHandCursor = true;
			return b;
		}

		/**
		 * this function creates a blank grid
		 */
		private function makeBlank(rows:int, columns:int):Sprite {
			// number of objects to place into grid
			var numObjects:int = rows*columns;

			// object that populates grid cell
			var cell:Sprite;
			for(var r:int = 0; r < rows; r++){
				for(var c:int = 0; c < columns; c++){
					// make object to place into grid
					cell = new Sprite();
					
					var g:Graphics = cell.graphics;
					g.lineStyle(1, 0xCCCCCC);
					g.beginFill(0xF2F2F2);
					g.drawRoundRect(0, 0, 32, 32, 0);
					g.endFill();
					
					cell.mouseEnabled;
					cell.buttonMode = true;
					cell.addEventListener(MouseEvent.CLICK, leftClick);
					cell.addEventListener(MouseEvent.MOUSE_OVER, altClick);
					cell.addEventListener(MouseEvent.CLICK, ctrlClick);
					
					// position object based on its width, height, column a row
					cell.x = cell.width * c;
					cell.y = cell.height * r;
					
					if (r == 0 || r == rows - 1 || c == 0 || c == columns - 1) {
						//If end of level
						cell.addChild(new wallImg());
						cell.name = "x";
					}
					grid.addChild(cell);
				}
			}
			
			grid.x = 20;
			grid.y = 100;
			return grid;
		}
		
		/**
		 * 	Event Listeners Section
		 * 
		 */
		private function altClick(e:MouseEvent):void{
			var sprite:Sprite = Sprite(e.target);
			if(e.altKey){
				//switch to check what trigger is active
				switch(activeButton){
					case wall: sprite.name = "x"; sprite.addChild(new wallImg()); break;
					case wood: sprite.addChild(new woodImg()); sprite.name = "w"; break;
					case steel: 
						sprite.addChild(new woodImg()); //TODO change this to steel
						sprite.name = "s";
						break;
					case playerspawn: sprite.addChild(new flagImg()); sprite.name = "#"; break;
					default:
				}
			}
		}
		
		private function leftClick(e:MouseEvent):void {
			var gridChild:Sprite = Sprite(e.target)
			
			//TODO make undo
			var undoAction:Object = new Object;
			undoAction.oldsprite = gridChild;
			//switch to check what trigger is active
			switch(activeButton){
				case wall: gridChild.name = "x"; gridChild.addChild(new wallImg()); break;
				case wood: gridChild.addChild(new woodImg()); gridChild.name = "w"; break;
				case steel: 
					gridChild.addChild(new woodImg()); //TODO change this to steel
					gridChild.name = "s";
					break;
				case playerspawn: gridChild.addChild(new flagImg()); gridChild.name = "#"; break;
				default:
			}
			undoAction.newsprite = gridChild;
			undoList.push(undoAction);
		}

		private function ctrlClick(e:MouseEvent):void {
			var gridChild:Sprite = Sprite(e.target)
			if (e.ctrlKey) {
				var i:int;
				while (gridChild.numChildren > 0) {
					gridChild.removeChildAt(0);
				}
				gridChild.name = " ";
			}
		}
		
		private function startClick(e:MouseEvent):void {
			var button:Button = Button(e.target);
			activeButton = playerspawn;
		}
		private function wallClick(e:MouseEvent):void {
			var button:Button = Button(e.target);
			activeButton = wall;
		}
		
		private function woodBoxClick(e:MouseEvent):void {
			var button:Button = Button(e.target); // focus mouse event
			activeButton = wood;
		}

		private function clearClick(e:MouseEvent):void {
			var button:Button = Button(e.target);
			grid.removeChildren();
			grid = makeBlank(this.levelRows, this.levelColumns);
			this.addChild(grid);
		}
		
		private function undoClick(e:MouseEvent):void{
			//TODO
			var button:Button = Button(e.target);
			if(undoList.length > 0){
				var lastAction:Object = undoList.pop;
				undoList.newsprite = undoList.oldsprite;
			}
			
		}
		
		private function resizeClick(e:MouseEvent):void{
			var button:Button = Button(e.target);
			setColumns(int(widthBox.text), int(heightBox.text));
			grid.removeChildren();
			grid = makeBlank(this.levelRows, this.levelColumns);
			this.addChild(grid);
			removeChild(scrollBar);
			removeChild(scroll);
			scrollBar = new FullScreenScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(scrollBar);
			scroll = new HorizontalBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(scroll);
		}
		
		/**
		 * This function returns to the title menu
		 */
		public function gotoMainMenu():void{
			deleteSelf();
			mainMenu.addMainMenu();
		}
		
		/**
		 * This function deletes level editor and moves on to level page
		 */
		private function testGame(e:MouseEvent):void {
			deleteSelf();
			this.addChild(new LevelPage());
		}
		
		/**
		 * This function is called from DropDownMenu to delete this object
		 * so that we can return to the main menu
		 */
		private function deleteSelf():void{
			this.removeChild(tf);
			this.removeChild(wallButton);
			this.removeChild(woodButton);
			this.removeChild(playerSpawnButton);
			this.removeChild(clearButton);
			this.removeChild(grid);
			this.removeChild(scrollBar);
			this.removeChild(scroll);
			this.removeChild(widthBox);
			this.removeChild(widthf);
			this.removeChild(heightBox);
			this.removeChild(heightf);
			this.removeChild(testButton);
			this.removeChild(title);
			this.removeChild(undoButton);
			this.removeChild(titlef);
			this.removeChild(resizeButton);
		}
	}
}
