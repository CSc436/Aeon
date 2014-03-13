package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.controls.UIScrollBar;
	
	import org.interguild.Aeon;
	import org.interguild.game.level.LevelPage;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Sprite {
		//Following is code to import images for everything
		[Embed(source = "../../../../images/testButton.png")] private var TestButton:Class;
		[Embed(source = "../../../../images/clearAllButton.png")] private var ClearButton:Class;
		[Embed(source = "../../../../images/wallButton.png")] private var WallButton:Class;
		[Embed(source = "../../../../images/woodButton.png")] private var WoodButton:Class;
		[Embed(source = "../../../../images/startButton.png")] private var StartButton:Class;
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
		private var tf:TextArea;
		public  var title:TextInput;
		private var undoButton:Button;
		private var redoButton:Button;

		private var gridContainer:Sprite;
		private var maskGrid:Sprite;

		private var dropDown:DropDownMenu;

		private var mainMenu:Aeon;
		
		private var scrollBar:UIScrollBar;
		// UNDO REDO ACTIONS ARRAYLIST
		private var undoList:Array;
		private var redoList:Array;
		//Following variables are toggles for when adding items to GUI
		private var isWall:Boolean = false;
		private var isWoodBox:Boolean = false;
		private var isSteelBox:Boolean = false;
		private var isStart:Boolean = false;
		
		//size of level
		private var levelColumns:int, levelRows:int;
		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage(mainMenu:Aeon):void {
			this.mainMenu = mainMenu;
			
			//playerstart button
			playerSpawnButton = makeButton("Start", StartButton, 650, 50);
			playerSpawnButton.addEventListener(MouseEvent.CLICK, startClick);
			
			//wallbutton
			wallButton = makeButton("Wall", WallButton, 650, 100);
			wallButton.addEventListener(MouseEvent.CLICK, wallClick);
			
			//woodbutton:
			woodButton = makeButton("Wood", WoodButton, 650, 150);
			woodButton.addEventListener(MouseEvent.CLICK, woodBoxClick);
			
			//clear button:
			clearButton = makeButton("Clear All", ClearButton, 650, 250);
			clearButton.addEventListener(MouseEvent.CLICK, clearClick);
			
			//Test button:
			testButton = makeButton("Test Game", TestButton, 350, 50);
			testButton.addEventListener(MouseEvent.CLICK, testGame);
			
			undoList = new Array();
			redoList = new Array();
			
			//undo button:
			undoButton = new Button();
			undoButton.label = "Undo";
			undoButton.x = 650;
			undoButton.y = 275;
			undoButton.useHandCursor = true;
			undoButton.addEventListener(MouseEvent.CLICK, undoClick);
			
			//title text field
			var titlef:TextField = new TextField();
			titlef.text = "Title:";
			titlef.x= 25;
			titlef.y = 50;
			titlef.backgroundColor(0xFFFFFF);
			//for entering a title name
			title = new TextInput();
			title.width = 250;
			title.height = 25;
			title.x = 55;
			title.y = 50;
			
			//textfield:
			tf = new TextArea();
			tf.width = 200;
			tf.height = 400;
			tf.x = 600;
			tf.y = 25;
			tf.editable = false;
			
			// Sprite that holds grid
			maskGrid = new Sprite();

			//add the drop down menu
			dropDown = new DropDownMenu(maskGrid, this);
			dropDown.x = 5;
			dropDown.y = 5;

			//default this level size
			setColumns(15, 15);
			maskGrid = makeBlank(maskGrid);
			
			// Arguments: Content to scroll, track color, grabber color, grabber press color, grip color, track thickness, grabber thickness, ease amount, whether grabber is “shiny"
			scrollBar = new UIScrollBar();
			scrollBar.setSize(maskGrid.width, maskGrid.height);
			scrollBar.move(-10,0);
			maskGrid.addChild(scrollBar);
			
			addChild(title);
			addChild(titlef);
			addChild(testButton);
			addChild(tf);
			addChild(wallButton);
			addChild(woodButton);
			addChild(playerSpawnButton);
			addChild(clearButton);
			addChild(maskGrid);
			addChild(dropDown);
			addChild(undoButton);
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
		
		/**
		 * This function is given by the i/o buffer reader to create a new level
		 */
		public function setLevelSize(title:String, level:String, row:int, col:int):void{
			levelRows = row;
			levelColumns = col;
			this.title.text = title;
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
		private function makeBlank(grid:Sprite):Sprite {
			// number of objects to place into grid
			var numObjects:int = levelColumns*levelRows;
			//TODO make numObjects scale with size of grid

			// current row and column
			var row:int = 0;
			var column:int = 0;
			// distance between objects
			var gap:Number = 0;
			// object that populates grid cell
			var cell:Sprite;
			for (var i:int = 0; i < numObjects; i++) {
				column = i % levelColumns;
				row = int(i / levelColumns);

				// make object to place into grid
				cell = makeObject(i, row, column);
				// position object based on its width, height, column a row
				cell.x = (cell.width + gap) * column;
				cell.y = (cell.height + gap) * row;
				var bit:Bitmap;
				if (row == 0 || row == levelRows - 1) {
					bit = new wallImg();
					cell.addChild(bit);
					cell.name = "x";
				} else if (column == 0 || column == levelColumns - 1) {
					bit = new wallImg();
					cell.addChild(bit);
					cell.name = "x";
				}
				grid.addChild(cell);
			}
			grid.x = 20;
			grid.y = 100;
			return grid;
		}

		/**
		 * Creates Sprite instance and draws its visuals.
		 *
		 * @param   index
		 * @param   row
		 * @param   column
		 */
		private function makeObject(index:int, row:int, column:int):Sprite {
			var s:Sprite = new Sprite();

			var g:Graphics = s.graphics;
			g.lineStyle(1, 0xCCCCCC);
			g.beginFill(0xF2F2F2);
			g.drawRoundRect(0, 0, 32, 32, 0);
			g.endFill();

			s.mouseEnabled;
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK, gridClick);
			s.addEventListener(MouseEvent.MOUSE_OVER, altClick);
			s.addEventListener(MouseEvent.CLICK, rightGridClick);
			return s;
		}
		
		/**
		 * This function is called from DropDownMenu to delete this object
		 * so that we can return to the main menu
		 */
		public function deleteSelf():void{
			this.removeChild(tf);
			this.removeChild(wallButton);
			this.removeChild(woodButton);
			this.removeChild(playerSpawnButton);
			this.removeChild(clearButton);
			this.removeChild(maskGrid);
			this.removeChild(scrollBar);
			this.removeChild(testButton);
			this.removeChild(title);
			this.removeChild(undoButton);
			mainMenu.addMainMenu();
		}
		
		/**
		 * 	Event Listeners Section
		 * 
		 */
		private function altClick(e:MouseEvent):void{
			var sprite:Sprite = Sprite(e.target);
			if(e.altKey){
				var bit:Bitmap;
				//switch to check what trigger is active
				if(isWall){
					sprite.name = "x"
					bit = new wallImg();
					sprite.addChild(bit);
				}
				else if(isWoodBox){
					bit = new woodImg();
					sprite.addChild(bit);
					sprite.name = "w";
				}
				else if(isSteelBox){
					sprite.name = "s";
				}
				else if(isStart){
					bit = new flagImg();
					sprite.addChild(bit);
					sprite.name = "#";
				}
			}
		}
		private function gridClick(e:MouseEvent):void {
			var sprite:Sprite = Sprite(e.target)
			//tf.appendText(sprite.x + "," + sprite.y + "\n");
			var bit:Bitmap;
			//switch to check what trigger is active
			var undoAction:Object = new Object;
			undoAction.oldsprite = sprite;
			if(isWall){
				sprite.name = "x"
				bit = new wallImg();
				sprite.addChild(bit);
			}
			else if(isWoodBox){
				bit = new woodImg();
				sprite.addChild(bit);
				sprite.name = "w";
			}
			else if(isSteelBox){
				sprite.name = "s";
			}
			else if(isStart){
				bit = new flagImg();
				sprite.addChild(bit);
				sprite.name = "#";
			}
			undoAction.newsprite = sprite;
			undoList.push(undoAction);
		}

		private function rightGridClick(e:MouseEvent):void {
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
			clearBools();
			tf.text = "start";
			isStart = true;
		}
		private function wallClick(e:MouseEvent):void {
			var button:Button = Button(e.target);
			clearBools();
			tf.text = "wall";
			isWall = true;
		}
		
		private function woodBoxClick(e:MouseEvent):void {
			var button:Button = Button(e.target);
			clearBools();
			trace("wood");
			tf.text = "wood";
			isWoodBox = true;
		}

		private function clearClick(e:MouseEvent):void {
			var button:Button = Button(e.target);
			var i:int;
			maskGrid.removeChildren();
			maskGrid = makeBlank(maskGrid);
		}

		private function testGame(e:MouseEvent):void {
			this.removeChild(tf);
			this.removeChild(wallButton);
			this.removeChild(clearButton);
			this.removeChild(woodButton);
			this.removeChild(playerSpawnButton);
			this.removeChild(maskGrid);
			this.removeChild(testButton);
			this.removeChild(dropDown);
			this.removeChild(title);
			this.removeChild(undoButton);
			//go to level page
			var levelPage:LevelPage=new LevelPage();
			this.addChild(levelPage);
		}
		
		private function clearBools():void{
			isWall = false;
			isWoodBox = false;
			isSteelBox = false;
			isStart = false;
		}
		
		private function undoClick(e:MouseEvent):void{
			var button:Button = Button(e.target);
			if(undoList.length > 0){
				var lastAction:Object = undoList.pop;
				undoList.newsprite = undoList.oldsprite;
			}
			
		}
	}
}
