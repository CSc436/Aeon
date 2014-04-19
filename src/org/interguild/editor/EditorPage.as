package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	
	import flexunit.utils.ArrayList;
	
	import org.interguild.Aeon;
	import org.interguild.Page;
	import org.interguild.editor.scrollBar.FullScreenScrollBar;
	import org.interguild.editor.scrollBar.HorizontalBar;
	import org.interguild.game.Player;
	import org.interguild.game.level.LevelProgressBar;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;
	import org.interguild.loader.EditorLoader;
	import org.interguild.loader.Loader;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Page {

		private static const DEFAULT_LEVEL_WIDTH:uint = 15;
		private static const DEFAULT_LEVEL_HEIGHT:uint = 15;

		//Following is code to import images for everything
		[Embed(source = "../../../../images/editorButtons/test-default.png")]
		private var TestButton:Class;
		[Embed(source = "../../../../images/editorButtons/clear-default.png")]
		private var ClearButton:Class;
		[Embed(source = "../../../../images/editorButtons/resize-default.png")]
		private var ResizeButton:Class;
		
		[Embed(source = "../../../../images/editorTitles/teleportStart.png")]
		private var StartButton:Class;
		[Embed(source = "../../../../images/editorTitles/teleportFinish.png")]
		private var FinishButton:Class;
		[Embed(source = "../../../../images/editorTitles/floor.png")]
		private var WallButton:Class;
		[Embed(source = "../../../../images/editorTitles/woodBox.png")]
		private var WoodButton:Class;
		[Embed(source = "../../../../images/editorTitles/steelBox.png")]
		private var SteelButton:Class;
		[Embed(source = "../../../../images/editorTitles/keyCard.png")]
		private var CollectableButton:Class;
		[Embed(source = "../../../../images/editorTitles/lightningBlockUp.png")]
		private var LightningButtonUp:Class;
		[Embed(source = "../../../../images/editorTitles/lightningBlockDown.png")]
		private var LightningButtonDown:Class;
		[Embed(source = "../../../../images/editorTitles/lightningBlockLeft.png")]
		private var LightningButtonLeft:Class;
		[Embed(source = "../../../../images/editorTitles/lightningBlockRight.png")]
		private var LightningButtonRight:Class;
		//		[Embed(source = "../../../../images/editorTitles/platform.png")]
		//		private var PlatformButton:Class;
		
		/*
		//TODO new buttons
		StartButton
		FinishButton
		WallButton
		WoodButton
		SteelButton
		CollectableButton
		LightningButtonUp
		LightningButtonDown
		LightningButtonLeft
		LightningButtonRight
		*/

		//following are objects on this sprite
		private var playerSpawnButton:StartLineButton;
		private var wallButton:TerrainButton;
		private var clearButton:ClearAllButton;
		private var woodButton:WoodBoxButton;
		private var testButton;
		private var resizeButton;
		private var tf:Sprite;
		public var title:TextInput;
		private var widthBox:TextInput;
		private var heightBox:TextInput;
		private var undoButton:UndoButton;
		private var redoButton:RedoButton;
		private var titlef:TextField;
		private var widthf:TextField;
		private var heightf:TextField;
		
		private var loader:Loader;
		private var gridContainer:Sprite;
		private var gridMask:Sprite;
		private var grid:EditorGrid;
		private var tab:EditorTab;
		private var dropDown:DropDownMenu;

		private var mainMenu:Aeon;

		private var progressBar:LevelProgressBar;
		
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

		private static var activeButton:String = "";

		//size of level
//		private var levelColumns:int, levelRows:int;

		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage(mainMenu:Aeon):void {
			this.mainMenu = mainMenu;

			//playerstart button
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			var playerBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			playerBackground.width = 200;
			playerBackground.y = 60;
			playerSpawnButton = new StartLineButton();
			playerSpawnButton.y = 60;
			playerSpawnButton.x = 15;
			playerSpawnButton.width = 170;
			playerSpawnButton.height = 50;
			playerSpawnButton.addEventListener(MouseEvent.CLICK, startClick);
			
			//wallbutton
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			var wallBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			wallBackground.width = 200; 
			wallBackground.y = 120;
			wallButton = new TerrainButton();
			wallButton.y = 120;
			wallButton.x = 15;
			wallButton.width = 170;
			wallButton.height = 50;
			wallButton.addEventListener(MouseEvent.CLICK, wallClick);
			//woodbutton:
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes			
			var woodBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			woodBackground.width = 200; 
			woodBackground.y = 180;
			woodButton = new WoodBoxButton();
			woodButton.y = 180;
			woodButton.x = 15;
			woodButton.width = 170;
			woodButton.height = 50;
			woodButton.addEventListener(MouseEvent.CLICK, woodBoxClick);

			//clear button:
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			var clearBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			clearBackground.width = 200; 
			clearBackground.y = 240
			clearButton = new ClearAllButton();
			clearButton.x = 5;
			clearButton.y = 245;
			clearButton.width = 200;
			clearButton.height = 25;
			clearButton.addEventListener(MouseEvent.CLICK, clearClick);
			var arrowDown:ArrowDownButton = new ArrowDownButton();
			arrowDown.x = 100;
			arrowDown.y = 180
			addChild(arrowDown);
			//Test button:
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			testButton = new TestButton();
			testButton.x = 340;
			testButton.y = 40;
			testButton.width = 180;
			testButton.height = 50;	
			/* Buttons to add to the branch
			ClearAllButton
			RedoButton
			ResizeButton
			TestButton
			UndoButton
			
			//editor tiles
			ArrowDownButton
			ArrowUpBotton
			ArrowRightButton
			ArrowLeftButton
			CollectableButton
			FinishLineButton
			StartLineButton
			SteelBoxButton
			WoodBoxButton
			TerrainButton
			*/
			
			testButton.addEventListener(MouseEvent.CLICK, testGameButtonClick);

			//change size button:
			//TODO button from assets
			resizeButton = new ResizeButton();
			resizeButton.addEventListener(MouseEvent.CLICK, resizeClick);
			
			undoList = new Array();
			redoList = new Array();

			//undo button:
			//TODO button from assets
			undoButton = new UndoButton();
			undoButton.x = 110;
			undoButton.y = 250;
			undoButton.addEventListener(MouseEvent.CLICK, undoClick);
			//redobutton:
			//TODO button from assets
			redoButton = new RedoButton();
			redoButton.x = 110;
			redoButton.y = 300;
			redoButton.addEventListener(MouseEvent.CLICK, redoClick);
			
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
			tf = new Sprite();
			tf.x = 625;
			tf.y = 100;
			tf.graphics.beginFill(0xFFFFFF);
			tf.graphics.drawRect(0,0, 200,1000);
			tf.graphics.endFill();
			var maskTf:Sprite = new Sprite();
			maskTf.graphics.beginFill(0);
			maskTf.graphics.drawRect(0,0,200,375);
			maskTf.graphics.endFill();
			maskTf.x =625;
			maskTf.y = 100;
			tf.mask = maskTf;
			//add the drop down menu
			dropDown = new DropDownMenu(this);
			dropDown.x = 5;
			dropDown.y = 5;

			tab = new EditorTab();
			grid = tab.getCurrentGrid();
			
			//grid = new EditorGrid(DEFAULT_LEVEL_WIDTH, DEFAULT_LEVEL_HEIGHT);
			grid.x = 20;
			grid.y = 100;
			grid.addEventListener(MouseEvent.CLICK, leftClick, false, 0, true);
			grid.addEventListener(MouseEvent.MOUSE_OVER, altClick, false, 0, true);
			gridMask = new Sprite();
			gridMask.graphics.beginFill(0);
			gridMask.graphics.drawRect(0,0,550,370);
			gridMask.graphics.endFill();
			gridMask.x = 20;
			gridMask.y = 100;
			grid.mask = gridMask;
			addChild(gridMask);
			addChild(grid);
			// Arguments: Content to scroll, track color, grabber color, grabber press color, grip color, track thickness, grabber thickness, ease amount, whether grabber is “shiny”
			scrollBar = new FullScreenScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true, 580);
			scrollBar.y = 100;
			addChild(scrollBar);
			scroll = new HorizontalBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(scroll);
			
			var textScrollBar:FullScreenScrollBar = new FullScreenScrollBar(tf, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true,845);
			textScrollBar.y = 100;
			addChild(textScrollBar);
			//grid.addChild(scrollBar);
			//addChild(resizeButton);
			addChild(heightf);
			addChild(widthf);
			addChild(widthBox);
			addChild(heightBox);
			addChild(title);
			addChild(titlef);
			addChild(testButton);
			addChild(tf);
			tf.addChild(wallBackground);
			tf.addChild(wallButton);
			tf.addChild(woodBackground);
			tf.addChild(woodButton);
			tf.addChild(playerBackground);
			tf.addChild(playerSpawnButton);
			tf.addChild(clearBackground);
			tf.addChild(clearButton);
			//addChild(grid);
			addChild(dropDown);
			tf.addChild(undoButton);
			tf.addChild(redoButton);
			loader = new EditorLoader();
			loader.addInitializedListener(newGridReady);
			loader.addErrorListener(onLoadError);
		}
		/**
		 * Method is called when making a button to put background on then the button
		 */

		public function openLevel(data:String):void {
			loader.loadFromCode(data,"Editor");
			//adding in mask and new scrollbar
			resetComponents();
		}

		/**
		 * Called by EditorLoader
		 */
		
		public function newGridReady(title:String, newGrid:EditorGrid):void {
			this.title.text = title;
			if (grid) {
				removeChild(grid);
			}
			grid = newGrid;
			grid.x = 20;
			grid.y = 100;
			addChild(grid);
			resetComponents();
			grid.addEventListener(MouseEvent.CLICK, leftClick, false, 0, true);
			grid.addEventListener(MouseEvent.MOUSE_OVER, altClick, false, 0, true);
		}

		private function onLoadError(e:ArrayList):void {
			trace(e);
			returnFromError(e);
			//TODO display error to user
		}
		private function returnFromError(e:ArrayList):void{
			var aeon:Aeon = Aeon.getMe();
			aeon.returnFromError(e, "Editor");
		}
		
		/**
		 * Helps populate the sprite by setting up buttons
		 *
		 * @param   index
		 * @param   row
		 * @param   column
		 */
		private function makeButton(label:String, image:Class,xpixel:int, ypixel:int):Button {
			var b:Button = new Button();
			b.label = label;
			b.width = 50;
			b.height = 50;
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
			var cell:EditorCell = EditorCell(e.target);
			
			if (e.altKey) {
				undoList.push(grid.clone());
				//switch to check what trigger is active
				cell.setTile(activeButton);
			}
		}

		private function leftClick(e:MouseEvent):void {
			var cell:EditorCell = EditorCell(e.target);
			//TODO make undo
			undoList.push(grid.clone());
			if (e.ctrlKey) {
				cell.clearTile();
			}else{
				cell.setTile(activeButton);
			}
			
			//switch to check what trigger is active
		}

		private function startClick(e:MouseEvent):void {
			var button:StartLineButton = StartLineButton(e.target);
			activeButton = Player.LEVEL_CODE_CHAR;
		}

		private function wallClick(e:MouseEvent):void {
			var button:TerrainButton = TerrainButton(e.target);
			activeButton = Terrain.LEVEL_CODE_CHAR;
		}

		private function woodBoxClick(e:MouseEvent):void {
			var button:WoodBoxButton = WoodBoxButton(e.target); // focus mouse event
			activeButton = WoodCrate.LEVEL_CODE_CHAR;
		}

		private function clearClick(e:MouseEvent):void {
			grid.clearGrid();
		}

		private function undoClick(e:MouseEvent):void {
			//this function takes from the undo stack and puts it back on the grid
			if (undoList.length > 0) {
				var popped:EditorGrid = undoList.pop();
				redoList.push(grid.clone());
				newGridReady(this.title.text , popped);
			}
		}
		private function redoClick(e:MouseEvent):void{
			if(redoList.length >0){
				var popped:EditorGrid = redoList.pop();
				undoList.push(grid.clone());
				newGridReady(this.title.text , popped);
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
			scrollBar = new FullScreenScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true, 580);
			scrollBar.y = 100;
			addChild(scrollBar);
			scroll = new HorizontalBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(scroll);
		}

		private function resetComponents():void{
			//adding back mask, scrollbar, and listeners for undo grid
			gridMask = new Sprite();
			gridMask.graphics.beginFill(0);
			gridMask.graphics.drawRect(0,0,550,370);
			gridMask.graphics.endFill();
			gridMask.x = 20;
			gridMask.y = 100;
			grid.mask = gridMask;
			removeChild(scrollBar);
			removeChild(scroll);
			scrollBar = new FullScreenScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true, 750);
			scrollBar.y = 100;
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

		/**
		 * This function ask the grid for the code of the level so we may
		 * save this code
		 */
		public function getLevelCode():String {
			var string:String = "";
			string += this.title.text+"\n";
			string += this.grid.levelHeight+"x"+grid.levelWidth+"\n";
			string += this.grid.toStringCells();
			return string;
		}

		/**
		 * This function deletes level editor and moves on to level page
		 */
		private function testGameButtonClick(e:MouseEvent):void {
//			deleteSelf();
//			this.addChild(new LevelPage());
			var s:String = getLevelCode();
			Aeon.getMe().playLevelCode(s);
		}
		
		public function addTabListener(e:MouseEvent):void{
			var b:Button = new Button();
			tab.addTab();
			grid = tab.getCurrentGrid();
			
			//grid = new EditorGrid(DEFAULT_LEVEL_WIDTH, DEFAULT_LEVEL_HEIGHT);
			grid.x = 20;
			grid.y = 100;
			grid.addEventListener(MouseEvent.CLICK, leftClick, false, 0, true);
			grid.addEventListener(MouseEvent.MOUSE_OVER, altClick, false, 0, true);
			gridMask = new Sprite();
			gridMask.graphics.beginFill(0);
			gridMask.graphics.drawRect(0,0,550,370);
			gridMask.graphics.endFill();
			gridMask.x = 20;
			gridMask.y = 100;
			grid.mask = gridMask;
			addChild(gridMask);
			addChild(grid);
			// Arguments: Content to scroll, track color, grabber color, grabber press color, grip color, track thickness, grabber thickness, ease amount, whether grabber is “shiny”
			scrollBar = new FullScreenScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true, 580);
			scrollBar.y = 100;
			addChild(scrollBar);
			scroll = new HorizontalBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(scroll);
			
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
