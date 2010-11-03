package mfui.widgets.linkone
{
	import mx.core.UIComponent;
	
	public class Callout extends UIComponent
	{
		public function Callout(x:int, y:int)
		{
			super();
			this.graphics.beginFill(0xffaaaa, 0.5);
			this.graphics.lineStyle(0.5, 0, 0.75);
			this.graphics.drawCircle(x, y, 15);
		}
	}
}