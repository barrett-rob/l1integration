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
		
		private var _w:int;
		private var _h:int;
		private var _tile_x:int;
		private var _tile_y:int;
		private var _tile_level:int;
		private var _tile_source:String;
		private var _tile_image:TileImage;
		
		public function Tile(w:int, h:int, tile_source:String, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK, _click);
			
			this.width = this._w = w;
			this.height = this._h = h;
			this._tile_level = tile_level;
			this._tile_x = tile_x;
			this._tile_y = tile_y;
			this._tile_source = tile_source;
		}
		
		private function _click(e:MouseEvent):void
		{
			if (!_tile_image)
			{
				_load();
			}
		}
		
		private function _load():void
		{
			this.toolTip = _w + 'x' + _h + '\nlevel:' + _tile_level + ' (' + _tile_x + ':' + _tile_y + ')';
			
			this._tile_image = new TileImage(_w, _h, _tile_source, _tile_level + tile_level_offset, _tile_x, _tile_y);
			this.addElement(_tile_image);
		}
		
		/* TODO: coords resolve to level coords */
		/* TODO: coords resolve to next level down */

	}
}