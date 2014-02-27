package examples {
    import fl.controls.Button;
    import flash.events.*;
    import flash.geom.Rectangle;

    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class gridexample extends Sprite {
        private var viewer:Sprite = new Sprite; //200x200
        private var imageContainer:Sprite = new Sprite; //400x500
        private var allowDrag:Boolean = false;

        public function gridexample() {
            imageContainer.mask = new Sprite;
            viewer.addChild(imageContainer);

            //define the click area coords
            var clickCoords:Rectangle = new Rectangle();
            clickCoords.x = 10; //starts at x 10
            clickCoords.y = 10; //starts at y 10
            clickCoords.width = 100; //100 wide
            clickCoords.height = 100; //100 tall

            //add the click listener
            var clickArea:Sprite = hotSpot(imageContainer, clickCoords);
            clickArea.addEventListener(MouseEvent.CLICK, onHotSoptClick);


            imageContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            imageContainer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            imageContainer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			addChild(clickCoords);
			addChild(clickArea);
			addChild(imageContainer);
        }

        function onMouseMove(e:Event):void {
            //return if not dragging
            if (!allowDrag)
                return;

            //move the imageContainer in a -(negative) direction of the mouse
            //use an index relative to the size of the viewer and imageContainer
            var speed:Number = 0.5;
            imageContainer.x -= (viewer.width / imageContainer.width) * speed;
            imageContainer.y -= (viewer.height / imageContainer.height) * speed;

            //clean the positions so the image remains within the viewer
            if (imageContainer.x > 0)
                imageContainer.x = 0;
            if (imageContainer.x < -viewer.width)
                imageContainer.x = -viewer.width;
            if (imageContainer.y > 0)
                imageContainer.y = 0;
            if (imageContainer.y < -viewer.height)
                imageContainer.y = -viewer.height;
        }
		
        //hot spot factory
        function hotSpot(target:Sprite, coords:Rectangle):Sprite {
            //create the hotspot
            var hs:Sprite = new Sprite;
            hs.graphics.beginFill(0, 0);
            hs.graphics.drawRect(0, 0, coords.width, coords.height);
            hs.graphics.endFill();

            //add the hotspot to the target
            hs.x = coords.x;
            hs.y = coords.y;
            target.addChild(hs);

            return hs;
        }
		
        function onHotSoptClick(e:MouseEvent):void {
            //do something
        }
		
		function onMouseDown(e:Event):void {
			allowDrag = true;
		}
		
		function onMouseUp(e:Event):void {
			allowDrag = false;
		}
    }
}
