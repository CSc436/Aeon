package tests
{
	import org.interguild.game.KeyMan;
	

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite
	{
		public var gridTile:GridTileTest;
		public var steelCrate:SteelCrateTest;
		public var woodCreate:WoodCrateTest;
		public var keyMan:KeyMan;
	}
}