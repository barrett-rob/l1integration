package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	
	import spark.components.BorderContainer;
	
	public class Tile extends BorderContainer
	{
	
		public static const virtual_height:int = 1024;
		public static const virtual_width:int = 1024;

		
		private var _tile_container:TileContainer;
		private var _tile_x:int;
		private var _tile_y:int;
		private var _tile_level:int;
		private var _tile_image:TileImage;
		
		public function Tile(tile_container:TileContainer, w:int, h:int, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK, _click);
			
			this.setStyle('borderStyle', 'none');
			
			this._tile_container = tile_container;
			this.width = w;
			this.height = h;
			this._tile_level = tile_level;
			this._tile_x = tile_x;
			this._tile_y = tile_y;
			
			this.toolTip = 'level:' + (_tile_level + _tile_container.tile_level_offset) + ' (' + _tile_x + ':' + _tile_y + ')' + '\n' + w + 'x' + h;
		}
		
		public function get tile_source():String
		{		
			return _tile_container.tile_source;
		}
		
		public function get tile_level_offset():int
		{		
			return _tile_container.tile_level_offset;
		}
		
		public function get tile_level():int
		{		
			return _tile_level;
		}
		
		public function get tile_x():int
		{		
			return _tile_x;
		}
		
		public function get tile_y():int
		{		
			return _tile_y;
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
			this._tile_image = new TileImage(this);
			this.addElement(_tile_image);
		}
		
		internal function discard():void
		{
			if (_tile_image)
				_tile_image.discard();
			/* TODO: discard child tiles */
		}
		
		/* TODO: coords resolve to level coords */
		/* TODO: coords resolve to next level down */

	}
}