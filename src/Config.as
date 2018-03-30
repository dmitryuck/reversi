package 
{
	import flash.events.Event;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 */
	public class Config 
	{		
		private static var config:Object;
		
		private var urlLoader:URLLoader;
		
		public var onLoaded:Function;
		
		// Конструктор
		public function Config()
		{
			
		}
		
		// Взять значение конфига по имени
		public static function getVal(name:String):Object
		{
			if (config[name] != undefined)
			{
				return config[name];
			}
			
			return null;
		}
		
		// Загрузка конфигурации игры с файла
		public function loadConfig(fileName:String)
		{
			var urlRequest:URLRequest = new URLRequest(fileName);
			urlLoader = new URLLoader();
			
			urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			
			urlLoader.addEventListener(Event.COMPLETE, onConfigLoaded);
			
			urlLoader.load(urlRequest);
		}
		
		public function onConfigLoaded(evt:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, onConfigLoaded);
			
			config = urlLoader.data;
			
			onLoaded();
		}
	}
}