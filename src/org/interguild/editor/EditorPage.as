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
		//following are objects on the map
		private var startButt:Button;
		private var wallButt:Button;
		private var clearButt:Button;
		private var woodButt:Button;
		private var testButton:Button;
		private var tf:TextArea;
		public  var title:TextInput;
		//Following is code to import images for everything
		[Embed(source = "../../../../images/testButton.png")]
		private var TestButton:Class;

		[Embed(source = "../../../../images/clearAllButton.png")]
		private var ClearButton:Class;

		[Embed(source = "../../../../images/wallButton.png")]
		private var WallButton:Class;

		[Embed(source = "../../../../images/woodButton.png")]
		private var WoodButton:Class;
		
		[Embed(source = "../../../../images/startButton.png")]
		private var StartButton:Class;
		//following is temp imgs before finalized art is done
		[Embed(source = "../../../../images/wall.png")]
		private var wallImg:Class;
		
		[Embed(source = "../../../../images/woodBox.png")]
		private var woodImg:Class;
		
		[Embed(source = "../../../../images/flag.jpg")]
		private var flagImg:Class;

		private var gridContainer:Sprite;
		private var maskGrid:Sprite;

		private var dropDown:DropDownMenu;

		private var numColumns:int;

		private var mainMenu:Aeon;
		
		private var scrollBar:UIScrollBar;
		
		//Following variables are toggles for when adding items to GUI
		private var isWall:Boolean = false;
		private var isWoodBox:Boolean = false;
		private var isSteelBox:Boolean = false;
		private var isStart:Boolean = false;
		
		//size of level
		private var wLevel:int=15, hLevel:int=10;
		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage(mainMenu:Aeon):void {
			var bbb:Bitmap;
			this.mainMenu = mainMenu;
			
			//startingposition button
			bbb = new StartButton();
			startButt = new Button();
			startButt.label= "start";
			startButt.setStyle("icon", StartButton);
			startButt.x = 650;
			startButt.y = 50;
			startButt.useHandCursor = true;
			startButt.addEventListener(MouseEvent.CLICK, startClick);
			//wallbutton:
			bbb = new WallButton();
			wallButt = new Button();
			wallButt.label = "wal";
			wallButt.setStyle("icon", WallButton);
			wallButt.x = 650;
			wallButt.y = 100;
			wallButt.useHandCursor = true;
			wallButt.addEventListener(MouseEvent.CLICK, wallClick);
			
			bbb = new WoodButton();
			//woodbutton:
			woodButt = new Button();
			woodButt.label = "wood";
			woodButt.setStyle("icon", WoodButton);
			woodButt.x = 650;
			woodButt.y = 175;
			woodButt.useHandCursor = true;
			woodButt.addEventListener(MouseEvent.CLICK, woodBoxClick);

			bbb= new ClearButton();

			//clear button:
			clearButt = new Button();
			clearButt.label = "Clear All";
			clearButt.setStyle("icon", ClearButton);
			clearButt.x = 650;
			clearButt.y = 250;
			clearButt.useHandCursor = true;
			clearButt.addEventListener(MouseEvent.CLICK, clearClick);

			//Test button:
			testButton = new Button();
			testButton.label = "Test Game";
			testButton.setStyle("icon", TestButton);
			testButton.x = 350;
			testButton.y = 50;
			testButton.useHandCursor = true;
			testButton.addEventListener(MouseEvent.CLICK, testGame);
			
			//title text field
			var titlef:TextField = new TextField();
			titlef.text = "Title:";
			titlef.x= 25;
			titlef.y = 50;
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

			setColumns(wLevel);
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
			addChild(wallButt);
			addChild(woodButt);
			addChild(startButt);
			addChild(clearButt);
			addChild(maskGrid);
			addChild(dropDown);

		}

		private function setColumns(col:int):void {
			this.numColumns = col;
			dropDown.setColumns(col);
			dropDown.setRows(hLevel);
		}

		// creates a blank grid
		private function makeBlank(grid:Sprite):Sprite {
			// number of objects to place into grid
			var numObjects:int = wLevel*hLevel;
			//TODO make numObjects scale with size of grid

			// current row and column
			var row:int = 0;
			var column:int = 0;
			// distance between objects
			var gap:Number = 0;
			// object that populates grid cell
			var cell:Sprite;
			for (var i:int = 0; i < numObjects; i++) {
				column = i % numColumns;
				row = int(i / numColumns);

				// make object to place into grid
				cell = makeObject(i, row, column);
				// position object based on its width, height, column a row
				cell.x = (cell.width + gap) * column;
				cell.y = (cell.height + gap) * row;
				var bit:Bitmap;
				if (row == 0 || row == hLevel - 1) {
					bit = new wallImg();
					cell.addChild(bit);
					cell.name = "x";
				} else if (column == 0 || column == numColumns - 1) {
					bit = new wallImg();
					cell.addChild(bit);
					cell.name = "x";
				}
				//gridContainer.addChild(cell);
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
		 * 
		*/
		public function deleteSelf():void{
			this.removeChild(tf);
			this.removeChild(wallButt);
			this.removeChild(woodButt);
			this.removeChild(startButt);
			this.removeChild(clearButt);
			this.removeChild(maskGrid);
			this.removeChild(scrollBar);
			this.removeChild(testButton);
			mainMenu.addMainMenu();
		}
		public function setLevelSize(title:String, level:String, width:int,height:int):void{
			this.wLevel = width;
			this.hLevel = height;
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
			this.removeChild(wallButt);
			this.removeChild(clearButt);
			this.removeChild(woodButt);
			this.removeChild(startButt);
			this.removeChild(maskGrid);
			this.removeChild(testButton);
			this.removeChild(dropDown);
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
	}
}
