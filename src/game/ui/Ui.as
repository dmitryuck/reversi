package game.ui 
{
	import starling.display.Sprite;
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class UI extends Sprite 
	{
		public static var ui:UI;
		
		public function UI()
		{
			
		}
		
		// Загрузка окна
		public static function loadWindow(position:Point, name:String, type:Class = null, fileName:String = null):Window
		{
			var window:Window = new (type ? type : Window)(name, fileName);
			
			ui.addChild(window);
			
			window.position = position;
			
			return window;
		}
		
		// Найти окно по имени
		public static function findWindow(name:String):Window
		{
			return Window(ui.getChildByName(name));
		}
		
		// Удалить окно
		public static function destroyWindow(window:Window):void
		{
			ui.removeChild(window);
			
			window = null;
		}
		
		// Удалить все окна
		public static function destroyAllWindows():void
		{
			ui.removeChildren();
		}
		
		// Скрыть окно
		public static function hideWindow(window:Window):void
		{
			window.hideWindow();
		}
		
		// Показать окно
		public static function showWindow(window:Window):void
		{
			window.showWindow();
		}		
	}
}