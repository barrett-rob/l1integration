package mfui.widgets.linkone
{
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	
	public class CalloutContainer extends Canvas
	{
		public function CalloutContainer()
		{
			super();
			
			this.addEventListener(FlexEvent.ADD, _add);
			
			this.setStyle('backgroundColor', '0x000000');
		}
		
		private function _add(e:FlexEvent):void
		{
			/* set size to fit parent */
			
		}
	}
}