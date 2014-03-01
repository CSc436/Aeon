package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.TextArea;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Sprite {
		private var b:Button;
		private var b2:Button;
		private var b3:Button;
		private var tf:TextArea;

		[Embed(source = "../../../../images/testButton.png")]
		private var TestButton:Class;

		[Embed(source = "../../../../images/clearAllButton.png")]
		private var ClearButton:Class;

		[Embed(source = "../../../../images/wallButton.png")]
		private var WallButton:Class;

		[Embed(source = "../../../../images/wall.png")]
		private var wallImg:Class;

		private var gridContainer:Sprite;
		private var maskGrid:Sprite;

		private var dropDown:DropDownMenu;

		private var numColumns:int;

		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage():void {
			
			// Sprite that holds grid
			maskGrid = new Sprite();

			//add the drop down menu
			dropDown = new DropDownMenu(maskGrid);
			dropDown.x = 5;
			dropDown.y = 5;

			setColumns(15);
			maskGrid = makeBlank(maskGrid);

			//button:
			var b:Button = new Button();
			b.label = "Wall";
			b.setStyle("icon", WallButton);
			b.x = 650;
			b.y = 200;
			b.addEventListener(MouseEvent.CLICK, buttonClick);

			var bbb:Bitmap = new ClearButton();

			//clear button:
			var b2:Button = new Button();
			b2.label = "Clear All";
			b2.setStyle("icon", ClearButton);
			b2.x = 650;
			b2.y = 300;
			b2.useHandCursor = true;
			b2.addEventListener(MouseEvent.CLICK, clearClick);

			//Test button:
			var testButton:Button = new Button();
			testButton.label = "Test Game";
			testButton.setStyle("icon", TestButton);
			testButton.x = 200;
			testButton.y = 650;
			testButton.useHandCursor = true;
			testButton.addEventListener(MouseEvent.CLICK, testGame);
			addChild(testButton);
			//textfield:
			tf = new TextArea();
			tf.width = 200;
			tf.height = 400;
			tf.x = 600;
			tf.y = 150;
			tf.editable = false;
			tf.addEventListener(MouseEvent.CLICK, buttonClick);
			addChild(tf);
			addChild(b);
			addChild(b2);
			addChild(maskGrid);
			addChild(dropDown);

		}

		private function setColumns(col:int):void {
			this.numColumns = col;
			dropDown.setColumns(col);
		}

		// creates a blank grid
		private function makeBlank(grid:Sprite):Sprite {
			// number of objects to place into grid
			var numObjects:int = 225;
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
				if (row == 0 || row == numColumns - 1) {
					bit = new wallImg();
					cell.addChild(bit);
					cell.name = "W";
				} else if (column == 0 || column == numColumns - 1) {
					bit = new wallImg();
					cell.addChild(bit);
					cell.name = "W";
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
			s.addEventListener(MouseEvent.CLICK, rightGridClick);
			return s;
		}

		private function gridClick(e:MouseEvent):void {
			var sprite:Sprite = Sprite(e.target)
			//tf.appendText(sprite.x + "," + sprite.y + "\n");

			var bit:Bitmap = new wallImg();
			sprite.addChild(bit);

			sprite.name = "W";
		}

		private function rightGridClick(e:MouseEvent):void {
			var gridChild:Sprite = Sprite(e.target)
			if (e.ctrlKey) {
				tf.appendText("ctrlclick\n");
				var i:int;
				while (gridChild.numChildren > 0) {
					gridChild.removeChildAt(0);
				}
				gridChild.name = " ";
			}
		}

		private function buttonClick(e:MouseEvent):void {
			var button:Button = Button(e.target);
			tf.appendText("hi\n");
		}

		private function clearClick(e:MouseEvent):void {
			var button:Button = Button(e.target);
			tf.appendText("cleared\n");
			maskGrid = makeBlank(maskGrid);
		}

		//TODO make sure the test button plays the current game
		private function testGame(e:MouseEvent):void {

		}
	}
}
