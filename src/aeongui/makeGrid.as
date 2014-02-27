package aeongui {
	import fl.controls.Button;
	import fl.controls.TextArea;
	
	import flash.display.*;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class makeGrid extends Sprite {
		private var b:Button;
		private var b2:Button;
		private var b3:Button;
		private var tf:TextArea;

		[Embed(source="images/testButton.png")]
		private var TestButton:Class;

		[Embed(source="images/clearAllButton.png")]
		private var ClearButton:Class;

		[Embed(source="images/wallButton.png")]
		private var WallButton:Class;

		[Embed(source="images/wall.png")]
		private var wallImg:Class;

		private var gridContainer:Sprite;
		private var maskGrid:Sprite;

		private var dropDown:DropDownMenu;
		
		private var numColumns:int;

		/**
		 * Creates grid holder and populates it with objects.
		 */
		function makeGrid():void {
			//stop stage from scaling and stuff
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;

			//init bg
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			// Sprite that holds grid
			//gridContainer=new Sprite();
			maskGrid=new Sprite();
			//addChild(gridContainer);
			
			//add the drop down menu
			dropDown=new DropDownMenu(maskGrid);
			dropDown.x=5;
			dropDown.y=5;
			setColumns(15);
			maskGrid=makeBlank(maskGrid);
			//button:
			var b:Button=new Button();
			b.label="Wall";
			b.setStyle("icon", WallButton);
			b.x=650;
			b.y=200;
			b.addEventListener(MouseEvent.CLICK, buttonClick);

			var bbb:Bitmap=new ClearButton();

			//clear button:
			var b2:Button=new Button();
			b2.label="Clear All";
			b2.setStyle("icon", ClearButton);
			b2.x=650;
			b2.y=300;
			b2.useHandCursor=true;
			b2.addEventListener(MouseEvent.CLICK, clearClick);

			//Test button:
			var testButton:Button=new Button();
			testButton.label="Test Game";
			testButton.setStyle("icon", TestButton);
			testButton.x=200;
			testButton.y=650;
			testButton.useHandCursor=true;
			testButton.addEventListener(MouseEvent.CLICK, testGame);
			addChild(testButton);
			//textfield:
			tf=new TextArea();
			tf.width=200;
			tf.height=400;
			tf.x=600;
			tf.y=150;
			tf.editable=false;
			tf.addEventListener(MouseEvent.CLICK, buttonClick);
			addChild(tf);
			addChild(b);
			addChild(b2);
			addChild(maskGrid);
			addChild(dropDown);
			
		}
		private function setColumns(col:int):void{
			this.numColumns = col;
			dropDown.setColumns(col);
		}
		// creates a blank grid
		function makeBlank(grid:Sprite) {
			// number of objects to place into grid
			var numObjects:int=225;
			// number of columns in the grid
			var numCols = numColumns;
			// current column
			var column:int=0;
			// current row
			var row:int=0;
			// distance between objects
			var gap:Number=0;
			// object that populates grid cell
			var cell:Sprite;
			for (var i:int=0; i < numObjects; i++) {
				// calculate current column using modulo operator
				column=i % numCols;
				// calculate current row
				row=int(i / numCols);
				//fprintf("%d", i);
				//trace( "this: " + i);
				// make object to place into grid
				cell=makeObject(i, row, column);
				// position object based on its width, height, column a row
				cell.x=(cell.width + gap) * column;
				cell.y=(cell.height + gap) * row;
				//gridContainer.addChild(cell);
				grid.addChild(cell);
			}
			grid.x=20;
			grid.y=100;
			return grid;
		}

		/**
		 * Creates Sprite instance and draws its visuals.
		 * Arguments passed are used to create label.
		 * @param   index
		 * @param   row
		 * @param   column
		 */
		function makeObject(index:int, row:int, column:int):Sprite {
			var s:Sprite=new Sprite();
			var g:Graphics=s.graphics;
			g.lineStyle(1, 0xCCCCCC);
			g.beginFill(0xF2F2F2);
			g.drawRoundRect(0, 0, 32, 32, 0);
			g.endFill();
			s.mouseEnabled;
			s.buttonMode=true;
			s.addEventListener(MouseEvent.CLICK, gridClick);
			return s;
		}

		private function gridClick(e:MouseEvent) {
			var sprite:Sprite=Sprite(e.target)
			//tf.appendText(sprite.x + "," + sprite.y + "\n");

			var text:TextField=new TextField();
//			text.text="W";
			text.name="grid";
			text.x=text.y=5;
			sprite.addChild(text);

			//TODO get the object that we are clicking
			var bit:Bitmap=new wallImg();
			sprite.addChild(bit);

			sprite.name="W";
		}

		private function buttonClick(e:MouseEvent) {
			var button:Button=Button(e.target);
			tf.appendText("hi\n");
		}

		private function clearClick(e:MouseEvent) {
			var button:Button=Button(e.target);
			tf.appendText("cleared\n");
			maskGrid=makeBlank(maskGrid);
		}
		
		//TODO make sure the test button plays the current game
		private function testGame(e:MouseEvent) {
			
		}
	}
}
