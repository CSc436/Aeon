package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	
	import flexunit.utils.ArrayList;
	
	import org.interguild.Aeon;
	import org.interguild.editor.scrollBar.FullScreenScrollBar;
	import org.interguild.editor.scrollBar.HorizontalBar;
	import org.interguild.game.Player;
	import org.interguild.game.level.LevelProgressBar;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.SteelCrate;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;
	import org.interguild.loader.EditorLoader;
	import org.interguild.loader.Loader;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Sprite {

		private static const DEFAULT_LEVEL_WIDTH:uint = 15;
		private static const DEFAULT_LEVEL_HEIGHT:uint = 15;

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
		private var finishButton:FinishLineButton;
		private var playerSpawnButton:StartLineButton;
		private var wallButton:TerrainBoxButton;
		private var clearButton:ClearAllButton;
		private var woodButton:WoodBoxButton;
		private var steelButton:SteelBoxButton;
		private var collectButton:CollectableButton;
		private var testButton:TestButton;
		private var resizeButton:ResizeButton;
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
			//Finish line button
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			var finishBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(finishBackground, 0, 5,200);
			finishButton = new FinishLineButton();
			setButtonSize(finishButton, 40,5,120,40);
			finishButton.addEventListener(MouseEvent.CLICK, finishClick);
			
			//playerstart button
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			var playerBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(playerBackground, 0, 60, 200);
			playerSpawnButton = new StartLineButton();
			setButtonSize(playerSpawnButton, 35,60,160,35);
			playerSpawnButton.addEventListener(MouseEvent.CLICK, startClick);
			
			//wallbutton
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			var wallBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(wallBackground, 0, 120,200);
			wallButton = new TerrainBoxButton();
			setButtonSize(wallButton, 25,126, 170,35);
			wallButton.addEventListener(MouseEvent.CLICK, wallClick);
			//woodbutton:
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes			
			var woodBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(woodBackground, 0, 180,200);
			woodButton = new WoodBoxButton();
			setButtonSize(woodButton, 25,190, 160,35);
			woodButton.addEventListener(MouseEvent.CLICK, woodBoxClick);
			
			//steelbutton:
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes			
			var steelBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(steelBackground, 0 , 240, 200);
			steelButton = new SteelBoxButton();
			setButtonSize(steelButton, 25,243, 150,35);
			steelButton.addEventListener(MouseEvent.CLICK, steelBoxClick);
						//collectablebutton:
			//TODO:ADD COLLECTABLE LISTENER
			var collectBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(collectBackground, 0 , 300, 200);
			collectButton = new CollectableButton();
			setButtonSize(collectButton, 10, 306, 180,35);
			collectButton.addEventListener(MouseEvent.CLICK, collectClick);
			
			//four arrow directions
			//TODO: ADD ARROW LISTENERS
			var arrowDownBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(arrowDownBackground, 0, 360, 200);
			var arrowDown:ArrowDownButton = new ArrowDownButton();
			setButtonSize(arrowDown, 25, 360, 160, 40);
			arrowDown.addEventListener(MouseEvent.CLICK, arrowDownClick);
			var arrowUpBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(arrowUpBackground, 0, 420, 200);
			var arrowUp:ArrowUpButton = new ArrowUpButton();
			setButtonSize(arrowUp, 25, 420, 160, 40);
			arrowUp.addEventListener(MouseEvent.CLICK, arrowDownClick);
			var arrowLeftBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(arrowLeftBackground, 0, 480, 200);
			var arrowLeft:ArrowLeftButton = new ArrowLeftButton();
			setButtonSize(arrowLeft, 25, 480, 160, 40);
			arrowLeft.addEventListener(MouseEvent.CLICK, arrowDownClick);
			var arrowRightBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(arrowRightBackground,0,540,200);
			var arrowRight:ArrowRightButton = new ArrowRightButton();
			setButtonSize(arrowRight, 25, 540,160,40);
			arrowRight.addEventListener(MouseEvent.CLICK, arrowDownClick);
			//clear button:
			var clearBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(clearBackground, 0, 600, 200);
			clearButton = new ClearAllButton();
			setButtonSize(clearButton, 5, 605, 200,25);
			clearButton.addEventListener(MouseEvent.CLICK, clearClick);
			//undo button:
			var undoBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(undoBackground, 0, 660, 200);
			undoButton = new UndoButton();
			setButtonSize(undoButton, 55,665,100,25);
			undoButton.addEventListener(MouseEvent.CLICK, undoClick);
			//redobutton:
			var redoBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(redoBackground, 0, 725, 200);
			redoButton = new RedoButton();
			setButtonSize(redoButton, 57,725, 100,25);
			redoButton.addEventListener(MouseEvent.CLICK, redoClick);
		
			//Test button:
			var testBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(testBackground, 330,40, 200);
			testButton = new TestButton();
			setButtonSize(testButton, 345,42,160,25);
			testButton.addEventListener(MouseEvent.CLICK, testGameButtonClick);
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
			TerrainBoxButton
			*/
			//change size button:
			var resizeBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(resizeBackground, 735,37,150);
			resizeButton = new ResizeButton();
			setButtonSize(resizeButton, 745,37, 120, 35);
			resizeButton.addEventListener(MouseEvent.CLICK, resizeClick);
			undoList = new Array();
			redoList = new Array();

			//title text field
			titlef = new TextField();
			titlef.text = "Title:";
			titlef.textColor = 0xFFFFFF;
			titlef.x = 25;
			titlef.y = 50;
			//width text field
			widthf = new TextField();
			widthf.text = "Width:";
			widthf.textColor = 0xFFFFFF;
			widthf.x = 625;
			widthf.y = 35;
			//height text field
			heightf = new TextField();
			heightf.text = "Height:";
			heightf.textColor = 0xFFFFFF;
			heightf.x = 625;
			heightf.y = 60;
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
			widthBox.x = 680;
			widthBox.y = 35;
			heightBox = new TextInput();
			heightBox.width = 50;
			heightBox.height = 25;
			heightBox.x = 680;
			heightBox.y = 60;
			//textfield
			tf = new Sprite();
			tf.x = 625;
			tf.y = 100;
			tf.graphics.beginFill(0xFFFFFF);
			tf.graphics.drawRect(0,0, 200,1000);
			tf.graphics.endFill();
			var maskTf:Sprite = new Sprite();
			maskTf.graphics.beginFill(0);
			maskTf.graphics.drawRect(0,0,Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT-75);
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
			addChild(resizeBackground);
			addChild(resizeButton);
			addChild(heightf);
			addChild(widthf);
			addChild(widthBox);
			addChild(heightBox);
			addChild(title);
			addChild(titlef);
			addChild(testBackground);
			addChild(testButton);
			addChild(tf);
			tf.addChild(arrowDownBackground);
			tf.addChild(arrowDown);
			tf.addChild(arrowUpBackground);
			tf.addChild(arrowUp);
			tf.addChild(arrowLeftBackground);
			tf.addChild(arrowLeft);
			tf.addChild(arrowRightBackground);
			tf.addChild(arrowRight);
			tf.addChild(wallBackground);
			tf.addChild(wallButton);
			tf.addChild(woodBackground);
			tf.addChild(woodButton);
			tf.addChild(steelBackground);
			tf.addChild(steelButton);
			tf.addChild(collectBackground);
			tf.addChild(collectButton);
			tf.addChild(finishBackground);
			tf.addChild(finishButton);
			tf.addChild(playerBackground);
			tf.addChild(playerSpawnButton);
			tf.addChild(clearBackground);
			tf.addChild(clearButton);
			//addChild(grid);
			addChild(dropDown);
			tf.addChild(undoBackground);
			tf.addChild(undoButton);
			tf.addChild(redoBackground);
			tf.addChild(redoButton);
			loader = new EditorLoader();
			loader.addInitializedListener(newGridReady);
			loader.addErrorListener(onLoadError);
		}
		/**
		 * Method is called when making a button to put background on then the button
		 */
		public function setBackgroundSize(background:Bitmap, x:int, y:int, width:int):void{
			background.x = x;
			background.y = y;
			background.width = width;
		}
		public function setButtonSize(button:MovieClip,x:int, y:int, width:int, height:int):void{
			button.x = x;
			button.y = y;
			button.width = width;
			button.height = height;			
		}
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
		private function finishClick(e:MouseEvent):void {
			var button:FinishLineButton = FinishLineButton(e.target);
			//TODO: change this to finish line once done
			activeButton = Player.LEVEL_CODE_CHAR;
		}
		private function startClick(e:MouseEvent):void {
			var button:StartLineButton = StartLineButton(e.target);
			activeButton = Player.LEVEL_CODE_CHAR;
		}

		private function wallClick(e:MouseEvent):void {
			var button:TerrainBoxButton = TerrainBoxButton(e.target);
			activeButton = Terrain.LEVEL_CODE_CHAR;
		}

		private function woodBoxClick(e:MouseEvent):void {
			var button:WoodBoxButton = WoodBoxButton(e.target); // focus mouse event
			activeButton = WoodCrate.LEVEL_CODE_CHAR;
		}
		private function collectClick(e:MouseEvent):void {
			var button:CollectableButton = CollectableButton(e.target); // focus mouse event
			activeButton = Collectable.LEVEL_CODE_CHAR;
		}
		private function steelBoxClick(e:MouseEvent):void {
			var button:SteelBoxButton = SteelBoxButton(e.target); // focus mouse event
			activeButton = SteelCrate.LEVEL_CODE_CHAR;
		}
		private function arrowDownClick(e:MouseEvent):void {
			var button:ArrowDownButton = ArrowDownButton(e.target); // focus mouse event
//			activeButton = ArrowCrate.LEVEL_CODE_CHAR;
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
			scrollBar = new FullScreenScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true, 580);
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
