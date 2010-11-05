package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	import mx.core.LayoutContainer;
	import mx.events.FlexEvent;
	
	public class Tile extends LayoutContainer
	{
		
		internal var virtual_size:int;
		internal var level:int;
		internal var x_pos:int;
		internal var y_pos:int;
		
		internal var primary:Boolean = true;
		
		private var _tile_container:TileContainer;
		private var _tile_image:TileImage;
		
		internal var region:Rectangle;
		
		public function Tile(tile_container:TileContainer, level:int, tile_x:int, tile_y:int)
		{
			super();
			this.setStyle('borderStyle', 'solid');
			this.layout = 'absolute';
			this.clipContent = false;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheel);
			this.addEventListener(MouseEvent.CLICK, _click);
			this._tile_container = tile_container;
			this.level = level;
			this.x_pos = tile_x;
			this.y_pos = tile_y;
			set_size_and_position();
		}
		
		internal function get level_width():int
		{
			return this._tile_container.get_level_width(this.level);
		}
		
		internal function get column_count():int
		{
			return this._tile_container.get_column_count(this.level);
		}
		
		internal function set_size_and_position():void
		{
			this.width = this.height = this._tile_container.width / column_count;
			this.left = this.x_pos * this.width;
			this.top = this.y_pos * this.height;
			
			this.region = new Rectangle(Number(this.left), Number(this.top), this.width, this.height);
			
			this.toolTip = toString();
		}
		
		private function _creationComplete(e:FlexEvent):void
		{
		}
		
		internal function loadImage():void
		{
			if (_tile_image)
				return;
			this._tile_image = new TileImage(this, TileContainer.TILE_URI_ROOT 
				+ _tile_container.tile_uri_source 
				+ '&tileLevel=' + (level + _tile_container.tile_uri_level_offset) 
				+ '&tilePositionX=' + x_pos 
				+ '&tilePositionY=' + y_pos);
			this.addElement(_tile_image);
		}
		
		internal function discard():void
		{
			if (_tile_image)
				_tile_image.discard();
		}
		
		private function _click(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			trace('level', level, 
				'w:', _tile_container.get_level_width(level), 
				'h:', _tile_container.get_level_height(level), 
				'::', _tile_container.get_level_ratio(level));
			
			//			var _x_proportion:Number = e.localX / this.width;
			//			var _virtual_x:Number = (((_x_proportion + tile_x) * virtual_size) / level_width) / (level + 1);
			//			
			//			var _y_proportion:Number = e.localY / this.height;
			//			var _virtual_y:Number = (((_y_proportion + tile_y) * virtual_size) / level_width) / (level + 1);
			//			
			//			trace('\t local (' + e.localX + ':' + e.localY + ')' 
			//				+ '\t virtual (' + _virtual_x + ':' + _virtual_y 
			//				+ '\t dimensions (' + this.width + 'x' + this.height + ')')
		}
		
		private function _mouseWheel(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			/* show next level up or down */
			var l:int = (e.delta > 0) ? this.level + 1 : this.level - 1;
			_tile_container.display_level(l);
			return;
		}
		
		internal function add_tile(x_plus:int, y_plus:int):void
		{
			_tile_container.add_tile(this.level, this.x_pos + x_plus, this.y_pos + y_plus);
		}
		
		internal function register_image(w:Number, h:Number):void
		{
			_tile_container.register_image(this, w, h);
		}
		
		public override function toString():String
		{
			return 'tile ' + level + ':' + x_pos + ':' + y_pos + ' (' + this.width + 'x' + this.height + ')';
		}
	}
}