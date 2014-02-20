package org.interguild.game.tiles
{
	public interface Tile
	{
		/*
		function: getDestructibility()
		description: returns value indicating whether or not
			a tile should be destroyed and by what.
		param: None
		return: int
			0 = indestructible (terrain)
			1 = destructible by arrows and dynamite (steel)
			2 = destructible by arrows, dynamite and touch (wooden)
		*/
		function getDestructibility():int;
		
		/*
		function: isSolid()
		description: returns whether or not the tile is solid
			i.e. player/tiles can pass through it.
		param: None
		return: Boolean
		*/
		function isSolid():Boolean;
		/*
		function: isGravible()
		description: returns whether or not the tile is affected
			by simulated game gravity.
		param: None
		return: Boolean
		*/
		function isGravible():Boolean;
		
		/*
		function: doesKnockback()
		description: returns whether or not the tile knocks back
			the character/tile that has collided with it.
		param: None
		return: int
			0 = does not knockback
			>0 = amount to knockback
		*/
		function doesKnockback():int;
		
		/*
		function: isBuoyant()
		description: returns whether or not the tile can float.
		param: None
		return: Boolean
		*/
		function isBuoyant():Boolean;
	}
}