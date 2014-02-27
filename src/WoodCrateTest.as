package  {
	import flexunit.framework.Assert;

	import org.interguild.game.tiles.WoodCrate;

	/**
	 * Simple test class for WoodCrate, just tests the few
	 * methods it contains to make sure they are returning the correct
	 * information.
	 */
	public class WoodCrateTest {

		private var woodCrate:WoodCrate=new WoodCrate(0, 0);

		[Test]
		public function testGetDestructibility():void {
			Assert.assertEquals(2, woodCrate.getDestructibility());
		}

		[Test]
		public function testIsSolid():void {
			Assert.assertTrue(woodCrate.isSolid());
		}

		[Test]
		public function testIsGravible():void {
			Assert.assertFalse(woodCrate.isGravible());
		}

		[Test]
		public function testDoesKnockback():void {
			Assert.assertEquals(0, woodCrate.doesKnockback());
		}

		[Test]
		public function testIsBuoyant():void {
			Assert.assertTrue(woodCrate.isBuoyant());
		}
	}
}
