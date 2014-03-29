package org.interguild.editor {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import fl.controls.Button;
	import fl.controls.TextArea;
	import fl.controls.TextInput;

	import org.interguild.Aeon;
	import org.interguild.Page;
	import org.interguild.editor.scrollBar.FullScreenScrollBar;
	import org.interguild.editor.scrollBar.HorizontalBar;
	import org.interguild.loader.EditorLoader;
	import org.interguild.loader.Loader;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Page {

		private static const DEFAULT_LEVEL_WIDTH:uint = 15;
		private static const DEFAULT_LEVEL_HEIGHT:uint = 15;

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
		[Embed(source = "../../../../images/resizeButton.png")]
		private var ResizeButton:Class;
		[Embed(source = "../../../../images/woodBox.png")]
		private var woodImg:Class;
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
		public var title:TextInput;
		private var widthBox:TextInput;
		private var heightBox:TextInput;
		private var undoButton:Button;
		private var redoButton:Button;
		private var titlef:TextField;
		private var widthf:TextField;
		private var heightf:TextField;

		private var loader:Loader;
		private var gridContainer:Sprite;
		private var gridMask:Sprite;
		private var grid:EditorGrid;

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
//		private var levelColumns:int, levelRows:int;

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
			testButton.addEventListener(MouseEvent.CLICK, testGameButtonClick);

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
			titlef.x = 25;
			titlef.y = 50;
			//width text field
			widthf = new TextField();
			widthf.text = "Width:";
			widthf.x = 655;
			widthf.y = 15;
			//height text field
			heightf = new TextField();
			heightf.text = "Height:";
			heightf.x = 655;
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

			//add the drop down menu
			dropDown = new DropDownMenu(grid, this);
			dropDown.x = 5;
			dropDown.y = 5;

			grid = new EditorGrid(DEFAULT_LEVEL_WIDTH, DEFAULT_LEVEL_HEIGHT);
			grid.y = 100;

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


			loader = new EditorLoader();
			loader.addInitializedListener(loadLevelCode);
		}

		public function openLevel(data:String):void {
			loader.loadFromCode(data);
		}

		/**
		 * Called by EditorLoader
		 */
		public function loadLevelCode(title:String, newGrid:EditorGrid):void {
			this.title.text = title;
			if (grid) {
				removeChild(grid);
			}
			grid = newGrid;
			grid.y = 100;
			addChild(grid);
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
		 * 	Event Listeners Section
		 *
		 */
		private function altClick(e:MouseEvent):void {
			var sprite:Sprite = Sprite(e.target);
			if (e.altKey) {
				//switch to check what trigger is active
				switch (activeButton) {
					case wall:
						sprite.name = "x";
						sprite.addChild(new wallImg());
						break;
					case wood:
						sprite.addChild(new woodImg());
						sprite.name = "w";
						break;
					case steel:
						sprite.addChild(new woodImg()); //TODO change this to steel
						sprite.name = "s";
						break;
					case playerspawn:
						sprite.addChild(new flagImg());
						sprite.name = "#";
						break;
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
			switch (activeButton) {
				case wall:
					gridChild.name = "x";
					gridChild.addChild(new wallImg());
					break;
				case wood:
					gridChild.addChild(new woodImg());
					gridChild.name = "w";
					break;
				case steel:
					gridChild.addChild(new woodImg()); //TODO change this to steel
					gridChild.name = "s";
					break;
				case playerspawn:
					gridChild.addChild(new flagImg());
					gridChild.name = "#";
					break;
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
			grid.clearGrid();
		}

		private function undoClick(e:MouseEvent):void {
			//TODO
			var button:Button = Button(e.target);
			if (undoList.length > 0) {
				var lastAction:Object = undoList.pop;
				undoList.newsprite = undoList.oldsprite;
			}

		}

		private function resizeClick(e:MouseEvent):void {
			var w:Number = Number(widthBox.text);
			var h:Number = Number(heightBox.text);
			if (isNaN(w) || isNaN(h) || w <= 0 || h <= 0)
				throw new Error("Invalid Level Dimensions: '" + w + "' by '" + h + "'");
			grid.resize(h, w);

			//reset scrollbar
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
		public function gotoMainMenu():void {
//			deleteSelf();
//			mainMenu.initMainMenu();
			Aeon.getMe().gotoMainMenu();
		}

		public function getLevelCode():String {
//			var i:int;
//			var row:int;
//			var col:int;
//			var string:String = title.text + "\n" + this.levelColumns + "x" + this.levelRows + "\n";
//			for (i = 0; i < grid.numChildren; i++) {
//				row = i / this.levelColumns;
//				col = i % this.levelColumns;
//				if (grid.getChildAt(i) != null) {
//					if (grid.getChildAt(i).name.length == 1) {
//						string += grid.getChildAt(i).name;
//					} else {
//						string += " ";
//					}
//					if (col == levelColumns - 1) {
//						string += "\n";
//					}
//				}
//			}
//			return string;
			return "";
		}

		/**
		 * This function deletes level editor and moves on to level page
		 */
		private function testGameButtonClick(e:MouseEvent):void {
//			deleteSelf();
//			this.addChild(new LevelPage());
			var s:String = getLevelCode();
			Aeon.getMe().playLevelCode(s);
			trace(s);
		}

//		/**
//		 * This function is called from DropDownMenu to delete this object
//		 * so that we can return to the main menu
//		 */
//		private function deleteSelf():void{
//			this.removeChild(tf);
//			this.removeChild(wallButton);
//			this.removeChild(woodButton);
//			this.removeChild(playerSpawnButton);
//			this.removeChild(clearButton);
//			this.removeChild(grid);
//			this.removeChild(scrollBar);
//			this.removeChild(testButton);
//			this.removeChild(title);
//			this.removeChild(undoButton);
//			this.removeChild(titlef);
//		}
	}
}
