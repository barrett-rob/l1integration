package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	
	public class TileContainer extends BorderContainer
	{
		
		public static const TILE_URI_ROOT:String = 'http://a028856:8080/ria/linkone?';
		
		public var MAX_TILE_DEPTH:int = 6;
		
		public var VIRTUAL_TILE_SIZE:int = 0;
		
		internal var tile_uri_level_offset:int = 0;
		internal var tile_uri_source:String = null;
		
		private var _levels:Array = null;
		private var _current_level:int = -1;
		
		public function TileContainer()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
			this.setStyle('borderStyle', 'solid');
		}
		
		private function _creationComplete(e:FlexEvent):void
		{
		}
		
		public function set_size(w:int, h:int, t:int):void
		{
			this.width = w;
			this.height = h;
			this.VIRTUAL_TILE_SIZE = t;
		}
		
		/* TODO: handle resize event? or disallow resize? */
		
		public function set_source(tile_source:String, tile_level_offset:int):void
		{
			this.tile_uri_source = tile_source;
			this.tile_uri_level_offset = tile_level_offset;
			
			_discard_all_levels();
			
			/* create new levels array */
			_levels = new Array(MAX_TILE_DEPTH);
			for (var i:int = 0; i < _levels.length; i++)
				_levels[i] = [];
			
			/* top level */
			_create_level(0);
			display_level(0);
		}
		
		private function _discard_all_levels():void
		{		
			this.removeAllElements();
			this._current_level = -1;
			/* help the flash gc: discard refs to all tiles */
			var i:int, j:int;
			if (_levels)
			{
				for (i = _levels.length - 1; i >= 0; i--)
				{
					if (_levels[i] is Array)
					{
						var _level:Array = _levels[i];
						for (j = 0; j < _level.length; j++)
						{
							Tile(_level[j]).discard();
							delete _level[j];
						}
					}
					delete _levels[i];
				}
			}
		}
		
		private function _create_level(l:int):void
		{
			if (l >= MAX_TILE_DEPTH)
				/* don't create levels beyond MAX_TILE_DEPTH */
				return;
			
			var _level:Array = _levels[l];
			if (_level.length > 0)
				/* level already exists */
				return;
			
			/* start by creating (l+1)^2 tiles */
			var _level_width:int = l + 1;
			var i:int, j:int;
			for (i = 0; i < _level_width; i++)
			{
				for (j = 0; j < _level_width; j++)
				{
					_create_tile(l, i, j);
				}
			}
		}
		
		private function _create_tile(level:int, tile_x:int, tile_y:int):void
		{
			var tile:Tile = new Tile(this, level, tile_x, tile_y);
			tile.virtual_size = this.VIRTUAL_TILE_SIZE;
			var _level:Array = _levels[level];
			_level.push(tile);
			callLater(tile.loadImage);
		}
		
		internal function add_tile(level:int, tile_x:int, tile_y:int):void
		{
			_create_tile(level, tile_x, tile_y);
			_set_tile_sizes_and_positions(level);
		}
		
		private function _set_tile_sizes_and_positions(level:int):void
		{
			var i:int, _new_level_width:int;
			var _tile:Tile;
			var _level:Array = _levels[level];
			/* get new level_width */
			for (i = 0; i < _level.length; i++)
			{
				_tile = Tile(_level[i]);
				if (_tile.tile_x > _new_level_width)
					_new_level_width = _tile.tile_x;
				if (_tile.tile_y > _new_level_width)
					_new_level_width = _tile.tile_y;
			}
			++_new_level_width;
			/* inform tiles */
			for (i = 0; i < _level.length; i++)
			{
				_tile = Tile(_level[i]);
				_tile.level_width = _new_level_width;
				_tile.set_size_and_position();
			}
		}
		
		internal function display_level(l:int):void
		{
			if (l < 0)
				/* can't scroll further out */
				return;
			if (l >= _levels.length)
				/* can't scroll further in */
				return;
			if (l == _current_level)
				/* already positioned on level */
				return;
			
			this.removeAllElements();
			var _level:Array = _levels[this._current_level = l];
			for (var i:int = 0; i < _level.length; i++)
				this.addElement(_level[i]);
			
			/* create the next level down */
			_create_level(l + 1);
		}
	
	}
}