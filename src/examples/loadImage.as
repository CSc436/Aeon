package examples {
	import fl.controls.Button;
	import fl.controls.TextArea;
	
    import flash.display.*;
    import flash.net.URLRequest;
    import flash.events.*;

    public class loadImage extends Sprite {
		//DAFAQ??
		[Embed (source = "images/testButton.png")]
		private var TestButton:Class;
		private var tf;
		
        public function loadImage():void {
            var bbb:Bitmap = new TestButton();
//			addChild(bbb);
			
			var b:Button = new Button();
			b.setStyle("icon", TestButton);
			b.x = 0;
			b.y = 0;
			b.addEventListener(MouseEvent.CLICK, buttonClick);
			
			//textfield:
			tf = new TextArea();
			tf.width = 200;
			tf.height = 400;
			tf.x = 0;
			tf.y = 0;
			tf.editable = false;
			tf.addEventListener(MouseEvent.CLICK, buttonClick);
			addChild(tf);
			addChild(b);
			

        }
		private function buttonClick(e:MouseEvent) {
			var button:Button = Button(e.target);
			tf.appendText("Im a button click event!\n");
		}
    }
}
