package org.interguild {
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	public class Assets {
		
		/*
		 * MENU ASSETS
		 */
		
		public static const MAIN_MENU_BG:BitmapData = new MainMenuBG();
		public static const AEON_LOGO:MovieClip = new AeonLogo();
		
		public static const MENU_BTN_SELECT:BitmapData = new MenuButtonSelectBG();
		public static const MENU_BTN_CLICK:BitmapData = new MenuButtonClickBG();

		/*
		 * EDITOR ASSETS
		 */

		public static const HELP_TITLE:BitmapData = new HelpTitle();
		public static const LEVEL_PROPERTIES_BG:BitmapData = new LevelPropertiesBG();

		public static const TAB_ACTIVE_SPRITE:BitmapData = new TabActiveSprite();
		public static const TAB_INACTIVE_SPRITE:BitmapData = new TabInactiveSprite();
		public static const TAB_CLOSE_BUTTON_SPRITE:BitmapData = new TabCloseButtonSprite();
		public static const TAB_CLOSE_OVER_SPRITE:BitmapData = new TabCloseOverSprite();

		public static const PICTURE_BUTTON_UP:BitmapData = new PictureButtonUp();
		public static const PICTURE_BUTTON_OVER:BitmapData = new PictureButtonOver();

		public static const SELECTION_TOOL_SPRITE:BitmapData = new SelectionToolSprite();
		public static const ERASER_TOOL_SPRITE:BitmapData = new EraserToolSprite();

		public static const FILE_BUTTON_SPRITE:BitmapData = new FileButtonSprite();
		public static const FILE_MOUSE_OEVER_SPRITE:BitmapData = new FileMouseOverSprite();

		public static const PLAY_LEVEL_BUTTON:BitmapData = new PlayLevelButtonSprite();
		public static const PLAY_LEVEL_ROLLOVER:BitmapData = new PlayLevelRolloverSprite();
		public static const PUBLISH_BUTTON:BitmapData = new PublishButtonSprite();
		public static const PUBLISH_ROLLOVER:BitmapData = new PublishRolloverSprite();

		public static const EDITOR_BG:BitmapData = new EditorBG();

		/*
		 * LEVEL ASSETS
		 */

		public static const TREASURE_SPRITE:BitmapData = new CollectibleSprite();
		public static const FINISH_LINE:BitmapData = new FinishLineSprite();
		public static const STARTING_LINE:BitmapData = new StartLineSprite();
		public static const STEEL_CRATE:BitmapData = new SteelCrateSprite();
		public static const WOOD_CRATE:BitmapData = new WoodenCrateSprite();

		public static const ARROW_CRATE_RIGHT:BitmapData = new LightningBoxRight();
		public static const ARROW_CRATE_LEFT:BitmapData = new LightningBoxLeft();
		public static const ARROW_CRATE_UP:BitmapData = new LightningBoxUp();
		public static const ARROW_CRATE_DOWN:BitmapData = new LightningBoxDown();

		public static const DYNAMITE_WOOD_CRATE:BitmapData = new WoodenDynamiteSprite();

		public static const PAUSE_MENU_BG:BitmapData = new PauseMenuBG();
		
		public static const PLAYER_EDITOR_SPRITE:BitmapData = new StartingPositionSprite();
		public static const PLAYER_DEATH_SPRITE:BitmapData = new PlayerDeathSprite();

		/*
		 * TERRAIN TYPES
		 * We store them all in a list, for the editor
		 */

		private static var TT_MAP:Array;
		private static var TT_BITMAP:uint = 0;
		private static var TT_NAME:uint = 1;

		private static function initMapTT():void {
			TT_MAP = [];
			TT_MAP.push([new TerrainWoodSprite(), "Wood Pattern"]);
			TT_MAP.push([new TerrainSteelSprite(), "Steel Pattern"]);
		}

		private static function isInBoundsTT(id:Number):Boolean {
			if (TT_MAP == null)
				initMapTT();

			if (isNaN(id) || id < 0 || id >= TT_MAP.length)
				return false;
			else
				return true;
		}

		public static function getTerrainImage(id:Number):BitmapData {
			if (!isInBoundsTT(id))
				return null;

			return TT_MAP[id][TT_BITMAP];
		}

		public static function getTerrainName(id:Number):String {
			if (!isInBoundsTT(id))
				return null;

			return TT_MAP[id][TT_NAME];
		}

		/*
		 * LEVEL BACKGROUNDS
		 * We store them all in a list, for the editor
		 */

		private static var BG_MAP:Array;
		private static var BG_BITMAP:uint = 0;
		private static var BG_THUMBNAIL:uint = 1;
		private static var BG_NAME:uint = 2;

		private static function initMapBG():void {
			BG_MAP = [];
			BG_MAP.push([new BackgroundTeal(), new BackgroundTealMini(), "Teal"]);
			BG_MAP.push([new BackgroundGreen(), new BackgroundGreenMini(), "Green"]);
			BG_MAP.push([new BackgroundPurple(), new BackgroundPurpleMini(), "Purple"]);
		}

		private static function isInBoundsBG(id:Number):Boolean {
			if (BG_MAP == null)
				initMapBG();

			if (isNaN(id) || id < 0 || id >= BG_MAP.length)
				return false;
			else
				return true;
		}

		public static function getBGImge(id:Number):BitmapData {
			if (!isInBoundsBG(id))
				return null;

			return BG_MAP[id][BG_BITMAP];
		}

		public static function getBGThumbnail(id:Number):BitmapData {
			if (!isInBoundsBG(id))
				return null;

			return BG_MAP[id][BG_THUMBNAIL];
		}

		public static function getBGName(id:Number):String {
			if (!isInBoundsBG(id))
				return null;

			return BG_MAP[id][BG_NAME];
		}
	}
}
