package game.core 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class Display extends Sprite 
	{
		public static var display:Display;
		
		// Конструктор
		public function Display(parent:Sprite)
		{
			addEventListener(Event.ADDED_TO_STAGE, onCreate);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			
			parent.addChild(this);			
		}		
		
		// Дисплей создан
		private function onCreate(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onCreate);
			//addEventListener(Event.ENTER_FRAME, onUpdate);	
			
			scaleX = stage.stageWidth / 800;
			scaleY = stage.stageHeight / 480;
		}		
		
		// Дисплей удален
		private function onDestroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			//removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		public static function createScene():void
		{
			
		}
		
		//private function onUpdate(e:Event):void {}
	}
}