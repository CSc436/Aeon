package examples {
    import flash.display.*;
    import flash.net.URLRequest;
	import flash.events.*;

    public class loadImage extends Sprite {
        public function loadImage():void {
            var rect:Shape = new Shape();
            rect.graphics.beginFill(0xFFFFFF);
            rect.graphics.drawRect(0, 0, 100, 100);
            addChild(rect);

            var ldr:Loader = new Loader();
            ldr.mask = rect;

            var url:String = "http://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Ski_trail_rating_symbol-blue_square.svg/600px-Ski_trail_rating_symbol-blue_square.svg.png";

            var urlReq:URLRequest = new URLRequest(url);
            ldr.load(urlReq);
            addChild(ldr);
			
			LoadImage("C:\Users\Henry\Documents\Aeon\images\testButton.png");
			
			
			
        }
		function LoadImage(imageURL:String) {
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, ImageLoaded); // event listener which is fired when loading is complete
			imageLoader.load(new URLRequest(imageURL));
			addChild(imageLoader);
		}
		
		function ImageLoaded(e:Event) {
			e.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, ImageLoaded);
			this.addChild(e.target.loader.content); // loaded content is stored in e.target.loader.content variable
		}
    }
}
