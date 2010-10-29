package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	
	import spark.components.BorderContainer;
	
	public class Tile extends BorderContainer
	{
	
		public static const virtual_height:int = 1024;
		public static const virtual_width:int = 1024;

		public static var tile_level_offset:int = 0;
		
		internal var _w:int;
		internal var _h:int;
		internal var _tile_source:String;
		
		public function TileContainer(w:int, h:int, tile_source:String)
		{
			super();
			
			this.setStyle('borderStyle', 'none');
			
			this.width = this._w = w;
			this.height = this._h = h;
			this._tile_source = tile_source;
		}
		
		private function _load():void
		{
			/* create top level tile */
		}
		
	}
}