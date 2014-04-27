package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.interguild.Aeon;
	import org.interguild.editor.scrollBar.VerticalScrollBar;
	import org.interguild.game.Player;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.SteelCrate;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;
	import org.interguild.game.tiles.ArrowCrate;
	import org.interguild.game.tiles.FinishLine;
	public class EditorButtonContainer extends Page {
		//following are objects on this sprite
		
		private var activeButton:String="";
		private var finishButton:FinishLineButton;
		private var playerSpawnButton:StartLineButton;
		private var playerSpawn:Boolean=false;
		private var wallButton:TerrainBoxButton;
		private var clearButton:ClearAllButton;
		private var woodButton:WoodBoxButton;
		private var steelButton:SteelBoxButton;
		private var collectButton:CollectableButton;
		
		private var tf:Sprite;
		
		public function getActiveButton():String{
			return activeButton;
		}
		public function setActiveButton(tileCode:String):void{
			activeButton = tileCode;
		}
		public function EditorButtonContainer() {
			super();
		
			
			//Finish line button
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			var finishBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(finishBackground, 0, 5, 200);
			finishButton=new FinishLineButton();
			setButtonSize(finishButton, 40, 5, 120, 40);
			finishButton.addEventListener(MouseEvent.CLICK, finishClick);

			//playerstart button
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			var playerBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(playerBackground, 0, 60, 200);
			playerSpawnButton=new StartLineButton();
			setButtonSize(playerSpawnButton, 35, 60, 160, 35);
			playerSpawnButton.addEventListener(MouseEvent.CLICK, startClick);

			//wallbutton
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes
			var wallBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(wallBackground, 0, 120, 200);
			wallButton=new TerrainBoxButton();
			setButtonSize(wallButton, 25, 126, 170, 35);
			wallButton.addEventListener(MouseEvent.CLICK, wallClick);
			//woodbutton:
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes			
			var woodBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(woodBackground, 0, 180, 200);
			woodButton=new WoodBoxButton();
			setButtonSize(woodButton, 25, 190, 160, 35);
			woodButton.addEventListener(MouseEvent.CLICK, woodBoxClick);

			//steelbutton:
			//adding in the background to the images, all x,y are positioning and 
			// width/height are sizes			
			var steelBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(steelBackground, 0, 240, 200);
			steelButton=new SteelBoxButton();
			setButtonSize(steelButton, 25, 243, 150, 35);
			steelButton.addEventListener(MouseEvent.CLICK, steelBoxClick);

			//collectablebutton:
			var collectBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(collectBackground, 0, 300, 200);
			collectButton=new CollectableButton();
			setButtonSize(collectButton, 10, 306, 180, 35);
			collectButton.addEventListener(MouseEvent.CLICK, collectClick);

			//four arrow directions
			//TODO: ADD ARROW LISTENERS
			var arrowDownBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(arrowDownBackground, 0, 360, 200);
			var arrowDown:ArrowDownButton=new ArrowDownButton();
			setButtonSize(arrowDown, 25, 360, 160, 40);
			arrowDown.addEventListener(MouseEvent.CLICK, arrowDownClick);
			var arrowUpBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(arrowUpBackground, 0, 420, 200);
			var arrowUp:ArrowUpButton=new ArrowUpButton();
			setButtonSize(arrowUp, 25, 420, 160, 40);
			arrowUp.addEventListener(MouseEvent.CLICK, arrowUpClick);
			var arrowLeftBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(arrowLeftBackground, 0, 480, 200);
			var arrowLeft:ArrowLeftButton=new ArrowLeftButton();
			setButtonSize(arrowLeft, 25, 480, 160, 40);
			arrowLeft.addEventListener(MouseEvent.CLICK, arrowLeftClick);
			var arrowRightBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(arrowRightBackground, 0, 540, 200);
			var arrowRight:ArrowRightButton=new ArrowRightButton();
			setButtonSize(arrowRight, 25, 540, 160, 40);
			arrowRight.addEventListener(MouseEvent.CLICK, arrowRightClick);
			//clear button:
			var clearBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(clearBackground, 0, 600, 200);
			clearButton=new ClearAllButton();
			setButtonSize(clearButton, 5, 605, 200, 25);
			clearButton.addEventListener(MouseEvent.CLICK, clearClick);
			
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
			
			var textScrollBar:VerticalScrollBar = new VerticalScrollBar(tf, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true,845);
			textScrollBar.y = 100;
			addChild(textScrollBar);

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
			addChild(tf);
		}

		private function finishClick(e:MouseEvent):void {
			var button:FinishLineButton=FinishLineButton(e.target);
			//TODO: change this to finish line once done
			setActiveButton(FinishLine.LEVEL_CODE_CHAR);
		}

		private function startClick(e:MouseEvent):void {
			var button:StartLineButton=StartLineButton(e.target);
			setActiveButton(Player.LEVEL_CODE_CHAR);

		}
		public function isPlayerSpawn():Boolean{
			return playerSpawn;
		}
		public function setPlayerSpawn(bool:Boolean):void{
			playerSpawn = bool;
		}
		private function wallClick(e:MouseEvent):void {
			var button:TerrainBoxButton=TerrainBoxButton(e.target);
			setActiveButton(Terrain.LEVEL_CODE_CHAR);
		}

		private function woodBoxClick(e:MouseEvent):void {
			var button:WoodBoxButton=WoodBoxButton(e.target); // focus mouse event
			setActiveButton(WoodCrate.LEVEL_CODE_CHAR);
		}

		private function collectClick(e:MouseEvent):void {
			var button:CollectableButton=CollectableButton(e.target); // focus mouse event
			setActiveButton(Collectable.LEVEL_CODE_CHAR);
		}

		private function steelBoxClick(e:MouseEvent):void {
			var button:SteelBoxButton=SteelBoxButton(e.target); // focus mouse event
			setActiveButton(SteelCrate.LEVEL_CODE_CHAR);
		}

		private function arrowDownClick(e:MouseEvent):void {
			var button:ArrowDownButton=ArrowDownButton(e.target); // focus mouse event
			activeButton = ArrowCrate.LEVEL_CODE_CHAR_DOWN;
		}
		private function arrowUpClick(e:MouseEvent):void {
			var button:ArrowUpButton=ArrowUpButton(e.target); // focus mouse event
			activeButton = ArrowCrate.LEVEL_CODE_CHAR_UP;
		}
		private function arrowLeftClick(e:MouseEvent):void {
			var button:ArrowLeftButton=ArrowLeftButton(e.target); // focus mouse event
			activeButton = ArrowCrate.LEVEL_CODE_CHAR_LEFT;
		}
		private function arrowRightClick(e:MouseEvent):void {
			var button:ArrowRightButton=ArrowRightButton(e.target); // focus mouse event
			activeButton = ArrowCrate.LEVEL_CODE_CHAR_RIGHT;
		}

		private function clearClick(e:MouseEvent):void {
			grid.clearGrid();
		}
	}
	

}
