package org.interguild {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	import org.interguild.game.tiles.Spike;

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
		public static const SECRET_AREA_ICON:BitmapData = new SecretAreaEditorIcon();

		public static const FILE_BUTTON_SPRITE:BitmapData = new FileButtonSprite();
		public static const FILE_MOUSE_OEVER_SPRITE:BitmapData = new FileMouseOverSprite();

		public static const PLAY_LEVEL_BUTTON:BitmapData = new PlayLevelButtonSprite();
		public static const PLAY_LEVEL_ROLLOVER:BitmapData = new PlayLevelRolloverSprite();
		public static const PUBLISH_BUTTON:BitmapData = new PublishButtonSprite();
		public static const PUBLISH_ROLLOVER:BitmapData = new PublishRolloverSprite();

		public static const EDITOR_BG:BitmapData = new EditorBG();
		
		public static const EDITOR_ICON_BG_ON_OVER:BitmapData = new EditorIconBGOnOver();
		public static const EDITOR_ICON_BG_ON_CLICK:BitmapData = new EditorIconBGOnClick();
		public static const EDITOR_ICON_NEW:BitmapData = new EditorIconNew();
		public static const EDITOR_ICON_OPEN:BitmapData = new EditorIconOpen();
		public static const EDITOR_ICON_SAVE:BitmapData = new EditorIconSave();
		public static const EDITOR_ICON_UNDO:BitmapData = new EditorIconUndo();
		public static const EDITOR_ICON_REDO:BitmapData = new EditorIconRedo();
		public static const EDITOR_ICON_ZOOM_IN:BitmapData = new EditorIconZoomIn();
		public static const EDITOR_ICON_ZOOM_OUT:BitmapData = new EditorIconZoomOut();
		public static const EDITOR_ICON_LEVEL_PROPS:BitmapData = new EditorIconLevelProps();
		public static const EDITOR_ICON_HELP:BitmapData = new EditorIconHelp();

		/*
		 * LEVEL ASSETS
		 */

		public static const TREASURE_SPRITE:BitmapData = new CollectibleSprite();
		public static const FINISH_LINE:BitmapData = new FinishLineSprite();
		public static const STARTING_LINE:BitmapData = new StartLineSprite();
		public static const STEEL_CRATE:BitmapData = new SteelCrateSprite();
		public static const WOOD_CRATE:BitmapData = new WoodenCrateSprite();
		public static const WOODEN_PLATFORM:BitmapData = ERASER_TOOL_SPRITE;
		
		public static const SPIKE_SPRITE:BitmapData = new SpikeSprite();
		public static const SPIKE_FLOOR_EDITOR:BitmapData = new SpikeFloorEditorIcon();
		public static const SPIKE_CEILING_EDITOR:BitmapData = new SpikeCeilingEditorIcon();
		public static const SPIKE_WALL_RIGHT_EDITOR:BitmapData = new SpikeWallRightEditorIcon();
		public static const SPIKE_WALL_LEFT_EDITOR:BitmapData = new SpikeWallLeftEditorIcon();
		
		public static const BOULDER:BitmapData = ERASER_TOOL_SPRITE;

		public static const ARROW_CRATE_WOOD_RIGHT:BitmapData = new WoodRocketRightSprite();
		public static const ARROW_CRATE_WOOD_LEFT:BitmapData = new WoodRocketLeftSprite();
		public static const ARROW_CRATE_WOOD_UP:BitmapData = new WoodRocketUpSprite();
		public static const ARROW_CRATE_WOOD_DOWN:BitmapData = new WoodRocketDownSprite();
		public static const ARROW_CRATE_STEEL_RIGHT:BitmapData = new SteelRocketRightSprite();
		public static const ARROW_CRATE_STEEL_LEFT:BitmapData = new SteelRocketLeftSprite();
		public static const ARROW_CRATE_STEEL_UP:BitmapData = new SteelRocketUpSprite();
		public static const ARROW_CRATE_STEEL_DOWN:BitmapData = new SteelRocketDownSprite();
		
		public static const DYNAMITE_SPRITE:BitmapData = new DynamiteSprite();

		public static const DYNAMITE_WOOD_CRATE:BitmapData = new WoodenDynamiteSprite();
		public static const DYNAMITE_STEEL_CRATE:BitmapData = new SteelDynamiteSprite();

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
