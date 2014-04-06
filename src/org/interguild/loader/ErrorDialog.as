package org.interguild.loader
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.GradientType; 
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	
	import fl.controls.Button;
	
	import flexunit.utils.ArrayList;
	import flash.text.TextFormat;

	public class ErrorDialog extends Sprite
	{
		private var source:String;
		private var content:TextField;
		private var header:TextField;
		private var scrolling:Boolean;
		private var scrollDirection:String;
		
		public function ErrorDialog(e:ArrayList, src:String):void
		{
			source = src;
			//main dialog box
			var rect:Shape = new Shape();
			rect.graphics.lineStyle(1);
			rect.graphics.beginFill(0XB2B2B2,1);
			rect.graphics.drawRect(0,0,300,160);
			addChild(rect);
			var txt:String = "";
			for (var i:int = 0; i < e.length(); i++){
				txt += "error " + String(i+1) + ": " + e.getItemAt(i);
				txt += "\n";
			}
			if(source.search("Loader") >= 0){
				txt += "\nExample level encoding:\n\n" +
					"The Name of My Level!\n" +
					"20x20\n" +
					"xxxxxxxxxxx...\n" +
					"...\n";
			}
			if(source == "Editor"){
				txt += "\nThe editor could not load level as encoded; " +
					"please correct the error(s) listed above and try again.\n"
			}
			var type:String = GradientType.LINEAR;
			var colors:Array = [0xAE0808, 0xffffff];  //E50808
			var alphas:Array = [1, 1]; 
			var ratios:Array = [0, 255]; 
			var spreadMethod:String = SpreadMethod.PAD; 
			var interp:String = InterpolationMethod.LINEAR_RGB; 
			var focalPtRatio:Number = 0;
			
			var matrix:Matrix = new Matrix(); 
			var boxWidth:Number = 100; 
			var boxHeight:Number = 100; 
			var boxRotation:Number = Math.PI/2; // 90° 
			var tx:Number = 0; 
			var ty:Number = 0; 
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty); 
			
			//header box
			var headerOutline:Shape = new Shape();
			headerOutline.graphics.lineStyle(1);
			headerOutline.graphics.beginGradientFill(type,  
				colors, 
				alphas, 
				ratios,  
				matrix,  
				spreadMethod,  
				interp,  
				focalPtRatio);
			headerOutline.graphics.drawRect(0,0, 300, 20);
			headerOutline.x = 0;
			headerOutline.y = 0;
			addChild(headerOutline);
			
			//format header text
			var headerFormat:TextFormat = new TextFormat();
			headerFormat.bold = true;
			headerFormat.color = 0x000000;
			headerFormat.size = 16;
			
			//title of dialog box
			var headerTxt:String = "Error(s) thrown by ";
			headerTxt += source;
			header = new TextField();
			header.text = headerTxt;
			header.setTextFormat(headerFormat);
			header.x = 5;
			header.y = 0;
			header.width = 275;
			header.height = 20;
			header.wordWrap = true;
			header.multiline = false;
			addChild(header);

			//outline for scrolling text area
			var outline:Shape = new Shape();
			outline.graphics.lineStyle(1);
			outline.graphics.beginFill(0,0);
			outline.graphics.drawRect(0,0, 275, 100);
			outline.x = 5;
			outline.y = 25;
			addChild(outline);
			content = new TextField();
			content.background = true;
			content.backgroundColor = 0Xffffff;
			content.text = txt;
			content.x = 5;
			content.y = 25;
			content.width = 275;
			content.height = 100;
			content.wordWrap = true;
			content.multiline = true;
			addChild(content);
			
			//scroll up button
			var up:Sprite = new Sprite();
			var upArrow:Shape = new Shape();
			upArrow.graphics.beginFill(0X7B0808,1);
			upArrow.graphics.lineStyle(1);
			upArrow.graphics.moveTo(5,0);
			upArrow.graphics.lineTo(10,10);
			upArrow.graphics.lineTo(0,10);
			upArrow.graphics.lineTo(5,0);
			upArrow.graphics.endFill();
			upArrow.x = 285;
			upArrow.y = 25;
			up.addChild(upArrow);
			up.addEventListener(MouseEvent.MOUSE_DOWN, scrollUp);
			addChild(up);
			
			//scroll down button
			var down:Sprite = new Sprite();
			var downArrow:Shape = new Shape();
			downArrow.graphics.beginFill(0X7B0808,1);
			downArrow.graphics.lineStyle(1);
			downArrow.graphics.lineTo(10,0);
			downArrow.graphics.lineTo(5,10);
			downArrow.graphics.lineTo(0,0);
			downArrow.graphics.endFill();
			downArrow.x = 285;
			downArrow.y = 45;
			down.addChild(downArrow);
			down.addEventListener(MouseEvent.MOUSE_DOWN, scrollDown);
			addChild(down);
			
			//close dialog box
			var close:Button = new Button();
			close.label = "Close";
			close.x = 100;
			close.y = 130;
			close.addEventListener(MouseEvent.CLICK, closeDialog);
			addChild(close); 
			
		}
		
		private function scrollUp(e:MouseEvent):void
		{
			scrolling = true;
			scrollDirection = "up";
			content.scrollV--;
			stage.addEventListener(MouseEvent.MOUSE_UP,stopScroll);
			stage.addEventListener(Event.ENTER_FRAME,checkButtons);
		}
		
		private function scrollDown(e:MouseEvent):void
		{
			scrolling = true;
			scrollDirection = "down";
			content.scrollV++;
			stage.addEventListener(MouseEvent.MOUSE_UP,stopScroll);
			stage.addEventListener(Event.ENTER_FRAME,checkButtons);
		}
		
		private function stopScroll(event:MouseEvent):void
		{
			stage.removeEventListener(Event.ENTER_FRAME,checkButtons);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopScroll);
			scrolling = false;
		}
		
		private function checkButtons(event:Event):void
		{
			if (scrolling)
			{
				if (scrollDirection =="down")
				{
					content.scrollV +=1;
				}
				else if (scrollDirection == "up")
				{
					content.scrollV -=1;
				}
			}
		}
		
		private function closeDialog(e:MouseEvent):void
		{
			if (this.parent != null)
			{
				this.parent.removeChild(this);
			}
		}
	}
}