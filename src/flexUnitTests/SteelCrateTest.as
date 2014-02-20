
package flexUnitTests {
	import flexunit.framework.Assert;

	import org.interguild.game.tiles.SteelCrate;

	public class SteelCrateTest {
		private var steelCrate:SteelCrate=new SteelCrate(0, 0);

		[Test]
		public function testGetDestructibility():void {
			Assert.assertEquals(1, steelCrate.getDestructibility());
		}

		[Test]
		public function testIsSolid():void {
			Assert.assertTrue(steelCrate.isSolid());
		}

		[Test]
		public function testIsGravible():void {
			Assert.assertFalse(steelCrate.isGravible());
		}

		[Test]
		public function testDoesKnockback():void {
			Assert.assertEquals(0, steelCrate.doesKnockback());
		}

		[Test]
		public function testIsBuoyant():void {
			Assert.assertFalse(steelCrate.isBuoyant());
		}
	}


}
