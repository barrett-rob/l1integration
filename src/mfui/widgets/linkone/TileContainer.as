package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	public class TileContainer extends Canvas
	{
		
		public static const TILE_URI_ROOT:String = 'http://a028856:8080/ria/linkone?';
		public var MAX_TILE_DEPTH:int;
		public var VIRTUAL_TILE_SIZE:int;
		
		private var _tile_uri_level_offset:int = 0;
		private var _tile_uri_source:String = null;
		private var _levels:Array = null;
		private var _current_level:int = -1;
		
		public function TileContainer()
		{
			super();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheel);
			
			this.setStyle('borderStyle', 'none');
			this.setStyle('borderVisible', 'false');
			this.setStyle('borderWeight', '0');
		}
		
		private function _creationComplete(e:FlexEvent):void
		{
			/* resize to square */
			this.width = this.height = this.VIRTUAL_TILE_SIZE = Math.min(this.width, this.height);
			this.validateSize();
			MAX_TILE_DEPTH = Math.ceil(Math.log(Math.max(this.VIRTUAL_TILE_SIZE))/Math.LN2);
		}
		
		/* TODO: handle resize event */
		
		public function setSource(tile_source:String, tile_level_offset:int):void
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
			_display_tile(0, new Point(0, 0));
		}
		
		
		internal function get tile_uri_level_offset():int
		{		
			return _tile_uri_level_offset;
		}
		
		internal function get tile_uri_source():String
		{		
			return _tile_uri_source;
		}
		
		private function _discard_all_levels():void
		{		
			this.removeAllElements();
			
			/* discard and dispose of references to existing tiles */
			this._current_level = -1;
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
							if (_level[j] is Tile)
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
			trace('creating level:', l, '(with', (n * n), 'tiles)');
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
		
		private function _display_tile(l:int, p:Point):void
		{
			if (l < 0)
				/* can't scroll further out */
				return;
			if (l >= _levels.length)
				/* can't scroll further in */
				return;
			
			this.removeAllElements();
			trace('target point', p, 'on level', l);
			
			this._current_level = l;
			var _level:Array = _levels[l];
			for (var i:int = 0; i < _level.length; i++)
			{
				var t:Tile = Tile(_level[i]);
				this.addElement(t);
			}
			/* create the next level down */
			this.callLater(_create_level, [(l + 1)]);
			this.validateNow();
			return;
		}
		
		private function _mouseWheel(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			/* target point is */
			var p:Point = new Point(e.localX, e.localY);
			/* target level (up or down) is */
			var l:int = (e.delta > 0) ? this._current_level + 1 : this._current_level - 1;
			/* display tile */
			_display_tile(l, p);
		}
	}
	
}