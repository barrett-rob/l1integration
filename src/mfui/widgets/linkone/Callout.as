package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	
	public class Callout extends UIComponent
	{
		private var _id:String, _description:String, _part_number:String;
		private var _x:Number, _y:Number;
		
		public function Callout(xml:XML, scaling_factor:Number)
		{
			super();
			
			// trace(xml);
			
			_x = xml.position.x;
			_y = xml.position.y;
			
			/* scale for level size */
			_x *= scaling_factor;
			_y *= scaling_factor;
			
			_id = xml.displayItemId;
			_part_number = xml.partNumber;
			_description = xml.description;
			
			if (_description)
				this.toolTip = _description;
			if (_description && _part_number)
				this.toolTip += '\n';
			if (_part_number)
				this.toolTip += 'Part No: ' + _part_number;

			this.graphics.beginFill(0xffffff, 0.75);
			this.graphics.lineStyle(1, 0, 1);
			this.graphics.drawCircle(_x, _y, 15);
			
			this.setStyle('color', 'blue');
			this.setStyle('fontSize', '9');
			this.setStyle('fontWeight', 'bold');
			this.setStyle('textAlign', 'center');
			
			var t:UITextField = new UITextField();
			t.text = _id;
			t.width = t.textWidth + 10;
			t.height = t.textHeight;
			// t.border = true;
			// t.borderColor = 0;
			t.x = _x - t.width / 2;
			t.y = _y - t.height / 2;

			this.addChild(t);
			this.addEventListener(MouseEvent.CLICK, _click);	
		}
		
		private function _click(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			trace('clicked callout ' + this._id + ' at ' + e.localX + ':' + e.localY);
			e.stopImmediatePropagation();
		}
	}
}