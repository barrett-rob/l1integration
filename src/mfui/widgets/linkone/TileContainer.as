package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	import mx.core.LayoutContainer;
	import mx.events.FlexEvent;
	
	public class TileContainer extends LayoutContainer
	{
		
		public static const TILE_URI_ROOT:String = 'http://a028856:8080/ria/linkone?';
		
		public var MAX_TILE_DEPTH:int = 6;
		
		public var VIRTUAL_TILE_SIZE:int = 0;
		
		internal var tile_uri_level_offset:int = 0;
		internal var tile_uri_source:String = null;
		
		private var _levels:Array = null;
		private var _column_counts:Array = null;
		private var _dimensions:Array = null;
		private var _current_level:int = -1;
		
		public function TileContainer()
		{
			super();
			this.setStyle('borderStyle', 'solid');
			this.layout = 'absolute';
			this.clipContent = false;
			addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
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
			_dimensions = new Array(_levels.length);
			_column_counts = new Array(_levels.length);
			for (var i:int = 0; i < _levels.length; i++)
			{
				_levels[i] = [];
				_dimensions[i] = new Rectangle();
			}
			
			
			/* top level */
			_create_level(0);
			display_level(0);
		}
		
		internal function get_level_width(l:int):Number
		{
			return Rectangle(_dimensions[l]).width;
		}
		
		internal function get_level_height(l:int):Number
		{
			return Rectangle(_dimensions[l]).height;
		}
		
		internal function get_level_ratio(l:int):Number
		{
			return get_level_width(l) / get_level_height(l);
		}
		
		internal function get_column_count(l:int):Number
		{
			return _column_counts[l];
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
			_levels = null;
			_dimensions = null;
			_column_counts = null;
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
			var _column_count:int = l + 1;
			_column_counts[l] = _column_count;
			var i:int, j:int;
			for (i = 0; i < _column_count; i++)
			{
				for (j = 0; j < _column_count; j++)
				{
					var _tile:Tile = _create_tile(l, i, j);
					callLater(_tile.loadImage);
				}
			}
		}
		
		private function _create_tile(level:int, tile_x:int, tile_y:int):Tile
		{
			var _tile:Tile = new Tile(this, level, tile_x, tile_y);
			_tile.virtual_size = this.VIRTUAL_TILE_SIZE;
			var _level:Array = _levels[level];
			_level.push(_tile);
			return _tile;
		}
		
		internal function add_tile(tile_level:int, tile_x:int, tile_y:int):void
		{
			var _tile:Tile = _create_tile(tile_level, tile_x, tile_y);
			_tile.primary = false;
			callLater(_tile.loadImage);
		}
		
		internal function register_image(tile:Tile, w:Number, h:Number):void
		{
			if (tile.y_pos == 0)
			{
				Rectangle(_dimensions[tile.level]).width += w;
			}
			if (tile.x_pos == 0)
			{
				Rectangle(_dimensions[tile.level]).height += h;
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