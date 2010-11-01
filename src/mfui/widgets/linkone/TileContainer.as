package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	
	public class TileContainer extends BorderContainer
	{
		
		public static const TILE_URI_ROOT:String = 'http://a028856:8080/ria/linkone?';
		public const MAX_TILE_DEPTH:int = 5; /* calculate this rather than guess? */
		
		public var virtual_tile_size:int = 0;
		
		private var _tile_uri_level_offset:int = 0;
		private var _tile_uri_source:String = null;
		private var _levels:Array = null;
		private var _current_level:int = -1;
		
		public function TileContainer()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
			this.setStyle('borderStyle', 'none');
		}
		
		private function _creationComplete(e:FlexEvent):void
		{
			/* resize to square */
			this.width = this.height = this.virtual_tile_size = Math.min(this.width, this.height);
			this.validateNow();
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
			display_level(0);
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
					var t:Tile = new Tile(this, this.width, this.height, l, i, j);
					_level.push(t);
					t.callLater(t.loadImage);
				}
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
			
			trace('displaying level:', l);
			this.removeAllElements();
			this._current_level = l;
			var _level:Array = _levels[l];
			for (var i:int = 0; i < _level.length; i++)
			{
				this.addElement(_level[i]);
			}
			
			/* create the next level down */
			_create_level(l + 1);
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