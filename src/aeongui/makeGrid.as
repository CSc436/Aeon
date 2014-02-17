package aeongui {
    import fl.controls.Button;
    import fl.controls.TextArea;

    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class makeGrid extends Sprite {
        private var b:Button;

        private var tf:TextArea;

        private var gridContainer:Sprite;
		private var maskGrid:Sprite;
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
            b.y = 200;
            b.addEventListener(MouseEvent.CLICK, buttonClick);

            //textfield:
            tf = new TextArea();
            tf.width = 200;
            tf.height = 400;
            tf.x = 600;
            tf.y = 200;
            tf.editable = false;
            tf.addEventListener(MouseEvent.CLICK, buttonClick);
            addChild(tf);
            addChild(b);
            // Sprite that holds grid
            gridContainer = new Sprite();
            maskGrid = new Sprite();
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
				maskGrid.addChild(cell);
            }
			maskGrid.x = maskGrid.y = 20;
            gridContainer.x = gridContainer.y = 20;
            maskGrid.addEventListener(MouseEvent.CLICK, buttonClick);

			addChild(gridContainer);
			addChild(maskGrid);
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
            s.mouseEnabled;
            s.buttonMode = true;
            s.addEventListener(MouseEvent.CLICK, gridClick);
            return s;
        }

        private function gridClick(e:MouseEvent) {
            var sprite:Sprite = Sprite(e.target)
            tf.appendText(sprite.x + "," + sprite.y + "\n" + sprite.getChildAt(0));
            if(!sprite.getChildByName("grid")){
				var text:TextField = new TextField();
            	text.text = "W";
				text.name = "grid";
            	text.x = text.y = 5;
				sprite.addChild(text);
			}
			else{
				sprite.removeChildAt(0);
			}
            
        }

        private function buttonClick(e:MouseEvent) {
            var button:Button = Button(e.target);
            tf.appendText("hi\n");
        }
    }

}
