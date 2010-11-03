package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	import mx.core.LayoutContainer;
	import mx.events.FlexEvent;
	
	public class TileContainer extends LayoutContainer
	{
		
		public static const TILE_URI_ROOT:String = 'http://a028856:8080/ria/linkone?';
		public var MAX_TILE_DEPTH:int;
		public var VIRTUAL_TILE_SIZE:int;
		
		private var _tile_uri_level_offset:int = 0;
		private var _tile_uri_source:String = null;
		private var _levels:Array = null;
		private var _current_level:int = -1;
		
		private var _callout_container:CalloutContainer;
		
		public function TileContainer()
		{
			super();
			this.layout = "absolute";
			this.left = this.top = 0;
			this.cacheAsBitmap = true;
			this.clipContent = false;
		}
		
		public function set_size(w:int, h:int, t:int):void
		{
			this.width = w;
			this.height = h;
			
			this.MAX_TILE_DEPTH = Math.ceil(Math.log(Math.max(this.VIRTUAL_TILE_SIZE = t))/Math.LN2);
			
			this._callout_container.width = this.width; 
			this._callout_container.height = this.height;
		}
		
		public function set calloutContainer(callout_container:CalloutContainer):void
		{
			if (this._callout_container)
				throw new Error('callout container is already set');
			this._callout_container = callout_container;
		}
		
		/* TODO: handle resize event */
		
		public function set_source(tile_source:String, tile_level_offset:int):void
		{
			this._tile_uri_source = tile_source;
			this._tile_uri_level_offset = tile_level_offset;
			
			_discard_all_levels();
			
			/* create new levels array */
			_levels = new Array(MAX_TILE_DEPTH);
			for (var i:int = 0; i < _levels.length; i++)
				_levels[i] = [];
			
			/* create new top level */
			_create_level(0);
			
			/* display top level */
			display_tile(0, new Point(0, 0));
		}
		
		
		internal function get tile_uri_level_offset():int
		{		
			return _tile_uri_level_offset;
		}
		
		internal function get tile_uri_source():String
		{		
			return _tile_uri_source;
		}
		
		private function _remove_all_tiles():void
		{
			this.removeAllElements();
		}
		
		private function _discard_all_levels():void
		{		
			_remove_all_tiles();
			
			/* delete all tile references */
			this._current_level = -1;
			if (_levels)
			{
				for (var i:int = _levels.length - 1; i >= 0; i--)
				{
					if (_levels[i] is Array)
					{
						var _level:Array = _levels[i];
						for (var j:int = 0; j < _level.length; j++)
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
			
			/* number of tiles is square of l+1 */
			var n:int = l + 1;
			// trace('creating level:', l, '(with', (n * n), 'tiles)');
			var i:int, j:int;
			for (i = 0; i < n; i++)
			{
				for (j = 0; j < n; j++)
				{
					var _region_width:int = this.width / (l + 1);
					var _region_left:int = i * _region_width;
					var _region_height:int = this.height / (l + 1);
					var _region_top:int = j * _region_height;
					
					var tile:Tile = new Tile(this, l, i, j);

					tile.virtual_height = tile.virtual_width = this.VIRTUAL_TILE_SIZE;
					
					tile.width = this.width;
					tile.left = i * this.width;
					tile.height = this.height;
					tile.top = j * this.height;
					
					tile.set_region(_region_left, _region_top, _region_width, _region_height);
					
					tile.callLater(tile.loadImage);
					_level.push(tile);
				}
			}
		}
		
		internal function display_tile(delta:int, p:Point):void
		{
			var l:int = (delta < 0) ? this._current_level - 1 : this._current_level + 1;
			
			if (l < 0)
				/* can't scroll further out */
				return;
			if (l >= _levels.length)
				/* can't scroll further in */
				return;
			
			_remove_all_tiles();
			
			// trace('source point', p, 'on level', this._current_level);
			
			var _level_width:int = 0;
			var _level_height:int = 0;
			var _level:Array = _levels[this._current_level = l];
			for (var i:int = 0; i < _level.length; i++)
			{
				var _tile:Tile = Tile(_level[i]);
				if (_tile.tile_x == 0)
					_level_width += _tile.width;
				if (_tile.tile_y == 0)
					_level_height += _tile.height;
				this.addElement(_tile);
			}

			/* create the next level down */
			this.callLater(_create_level, [(l + 1)]);
			
			/* center */
			
			trace(_level_width + 'x' + _level_height);
			var _left_offset:int = _level_width / 2;
			for (i = 0; i < _level.length; i++)
			{
				_tile = Tile(_level[i]);
				_tile.left = Number(_tile.left) - _left_offset;
			}
			
			
			/* TODO: center at mouse location? */
			this.validateNow();
		}
		
	}
	
}