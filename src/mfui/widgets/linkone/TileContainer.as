package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	
	public class TileContainer extends BorderContainer
	{
		
		public var virtual_tile_size:int = 0;
		
		private var _tile_uri_level_offset:int = 0;
		private var _tile_uri_source:String = null;
		
		private var _top_level_tile:Tile = null;
		
		public function TileContainer()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
			this.setStyle('borderStyle', 'none');
		}
		
		private function _creationComplete(e:FlexEvent):void
		{
			/* resize to grab biggest square in parent */
			this.width = this.height = this.virtual_tile_size = Math.min(this.parent.width, this.parent.height) - 10;
			this.validateNow();
		}
		
		/* TODO: handle resize event */
		
		public function setSource(tile_source:String, tile_level_offset:int):void
		{
			this._tile_uri_source = tile_source;
			this._tile_uri_level_offset = tile_level_offset;
			
			/* discard any existing tiles */
			if (_top_level_tile)
			{
				this.removeElement(_top_level_tile);
				_top_level_tile.discard();
			}
			
			/* create new top level tile */
			_top_level_tile = new Tile(this, this.width, this.height, 0, 0, 0);
			this.addElement(_top_level_tile);
		}
		
		public function get tile_uri_level_offset():int
		{		
			return _tile_uri_level_offset;
		}
		
		public function get tile_uri_source():String
		{		
			return _tile_uri_source;
		}
		
	}
}