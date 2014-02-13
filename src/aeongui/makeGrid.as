package aeongui
{
	import fl.controls.Button;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	public class makeGrid extends Sprite
	{
		private var b:Button;
		private var tf:TextField;
		/**
		 * Creates grid holder and populates it with objects.
		 */
		function makeGrid():void {
			//stop stage from scaling and stuff
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//init bg
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			//button:
			var b:Button = new Button();
			b.label = "Click Me";
			b.x = 600;
			b.y = 300;
			b.addEventListener(MouseEvent.CLICK,buttonClick);
			addChild(b);
			//textfield:
			tf = new TextField();
			tf.width = 200;
			tf.height = 400;
			tf.x = 600;
			tf.y = 400;
			tf.border = true;
			addChild(tf);
			
			// Sprite that holds grid
			var gridContainer:Sprite = new Sprite();
			// number of objects to place into grid
			var numObjects:int = 225;
			// number of columns in the grid
			var numCols:int = 15;
			// current column
			var column:int = 0;
			// current row
			var row:int = 0;
			// distance between objects
			var gap:Number = 0;
			// object that populates grid cell
			var cell:Sprite;
			for (var i:int = 0; i < numObjects; i++) {
				// calculate current column using modulo operator
				column = i % numCols;
				// calculate current row
				row = int(i / numCols);
				// make object to place into grid
				cell = makeObject(i, row, column);
				// position object based on its width, height, column a row
				cell.x = (cell.width + gap) * column;
				cell.y = (cell.height + gap) * row;
				gridContainer.addChild(cell);
				trace(i, "\tcolumn =", column, "row =", row);
			}
			gridContainer.x = gridContainer.y = 20;
			addChild(gridContainer);	
		}
		/**
		 * Creates Sprite instance and draws its visuals.
		 * Arguments passed are used to create label.
		 * @param   index
		 * @param   row
		 * @param   column
		 */
		function makeObject(index:int, row:int, column:int):Sprite {
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			g.lineStyle(1, 0xCCCCCC);
			g.beginFill(0xF2F2F2);
			g.drawRoundRect(0, 0, 32, 32, 0);
			g.endFill();
			return s;
		}
		private function buttonClick(e:MouseEvent) {
			var button:Button = Button(e.target);
			tf.appendText(button.label + "\n");
		}
	}
	
}