package loadandsave
{
	import fl.controls.Button;
	import fl.managers.StyleManager;
	import flash.display.*;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	
	[Event(name="select", type="flash.events.Event")]
	public class LoadStateView extends Sprite
	{
		// ------- Child controls -------
		public var _loadImageBtn:Button;
		
		
		// ------- Private vars -------
		private var loadBtnText:TextFormat;
		
		private var _showProgress : Boolean = false;
		
		private var _fileRef : FileReference;
		
		// ------- Constructor -------
		public function LoadStateView()
		{
			
			var imageFilter : FileFilter = new FileFilter("Image Files (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg; *.jpeg; *.gif; *.png");
			
			_fileRef = new FileReference();
			_fileRef.browse([imageFilter]);
			_fileRef.addEventListener(Event.SELECT, selectImageHandler);
			
			
			addEventListener(Event.ADDED, setupChildren);
			
		}
		
		
		private function selectImageHandler( evt : Event ) : void
		{
			// … display the progress bar for the loading operation …
			_fileRef.removeEventListener(Event.SELECT, selectImageHandler);
			_showProgress = true;
			_fileRef.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_fileRef.load();
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			_fileRef.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			_showProgress = false;
			
			// … display the progress bar for converting the image data to a display object …
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
			loader.loadBytes(_fileRef.data);
		}
		
		private function loadBytesHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
			loaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);
			
//			myImage.source = Bitmap(loaderInfo.content);
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


		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
			
			loadBtnText = new TextFormat();
			loadBtnText.size = 16;
			_loadImageBtn.setStyle("textFormat", loadBtnText);
			
			_loadImageBtn.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		
		private function clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.SELECT));
		}
	}
}