package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	public class Callout extends UIComponent
	{
		public function Callout(x:int, y:int, text:String = null)
		{
			super();
			this.graphics.beginFill(0xffaaaa, 0.5);
			this.graphics.lineStyle(0.5, 0, 0.75);
			this.graphics.drawCircle(x, y, 15);
			
			if (text)
			{
				var tf:TextField = new TextField();
				tf.text = text;
				tf.x = x - 10;
				tf.y = y - 10;
				/* TODO: better derivation of text position */
				this.addChild(tf);
			}
			
			this.addEventListener(MouseEvent.CLICK, _click);	
		}
		
		private function _click(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			trace('click at ' + e.localX + ':' + e.localY);
		}
	}
}