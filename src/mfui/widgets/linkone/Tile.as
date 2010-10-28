package mfui.widgets.linkone
{
	import mx.controls.Image;
	
	import spark.components.BorderContainer;
	
	public class Tile extends BorderContainer
	{
	
		public static const virtual_height:int = 1024;
		public static const virtual_width:int = 1024;

		private var _tileImage:TileImage;
		
		public function Tile(w:int, h:int, tile_source:String, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			this.width = w;
			this.height = h;
			this._tileImage = new TileImage(w, h, tile_source, tile_level, tile_x, tile_y);
			this.addElement(_tileImage);
		}
		
		/* TODO: click shows coords */
		/* TODO: coords resolve to level coords */
		/* TODO: coords resolve to next level down */

		
	}
}