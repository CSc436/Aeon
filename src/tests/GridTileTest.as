package tests {
	import flexunit.framework.Assert;

	import org.interguild.game.collision.GridTile;
	import org.interguild.game.tiles.SteelCrate;

	public class GridTileTest  {

		[Test]
		public function testAddRemoveObject():void {
			var gridTile:GridTile=new GridTile();


			var o:SteelCrate=new SteelCrate(0, 0);
			Assert.assertFalse(gridTile.containsObject(o));

			// add the object
			gridTile.addObject(o);
			Assert.assertTrue(gridTile.containsObject(o));

			// remove the object
			gridTile.removeObject(o);
			Assert.assertFalse(gridTile.containsObject(o));

		}


	}
}
