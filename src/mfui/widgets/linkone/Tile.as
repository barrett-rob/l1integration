package mfui.widgets.linkone
{
	import mx.controls.Image;
	
	import spark.components.BorderContainer;
	
	public class Tile extends BorderContainer
	{
	
		public static const virtual_height:int = 1024;
		public static const virtual_width:int = 1024;

		private var _w:int, _h:int, _tile_level:int,  _tile_x:int,  _tile_y:int;
		private var _tile_source:String;
		private var _tileImage:TileImage;
		
		public function Tile(w:int, h:int, tile_source:String, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			this.width = this._w = w;
			this.height = this._h = h;
			this._tile_level = tile_level;
			this._tile_x = tile_x;
			this._tile_y = tile_y;
			this._tile_source = tile_source;
			load();
		}
		
		private function load():void
		{
			this._tileImage = new TileImage(_w, _h, _tile_source, _tile_level, _tile_x, _tile_y);
			this.addElement(_tileImage);
		}
		
		/* TODO: click shows coords */
		/* TODO: coords resolve to level coords */
		/* TODO: coords resolve to next level down */

	}
}