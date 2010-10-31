package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	
	public class TileContainer extends BorderContainer
	{
		
		public const MAX_TILE_DEPTH:int = 5;
		public var virtual_tile_size:int = 0;
		
		private var _tile_uri_level_offset:int = 0;
		private var _tile_uri_source:String = null;
		private var _levels:Array = null;
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
			
			/* create new levels array */
			_levels = new Array(MAX_TILE_DEPTH);
			for (var i:int = 0; i < _levels.length; i++)
				_levels[i] = [];
			
			/* create new top level tile */
			_levels[0][0] = _top_level_tile = new Tile(this, this.width, this.height, 0, 0, 0);
			this.addElement(_top_level_tile);
		}
		
		private function _discard_all_levels():void
		{		
			/* discard any existing tiles */
			var i:int, j:int;
			if (_top_level_tile)
				this.removeElement(_top_level_tile);
			if (_levels)
			{
				for (i = _levels.length - 1; i >= 0; i--)
				{
					if (_levels[i] is Array)
					{
						var _level:Array = _levels[i];
						for (j = 0; j < _level.length; j++)
						{
							if (_level[j] is Tile)
								Tile(_level[j]).discard();
							delete _level[j];
						}
					}
					delete _levels[i];
				}
			}
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