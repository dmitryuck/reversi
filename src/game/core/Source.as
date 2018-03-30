package game.core 
{	
	import flash.display.Loader;
	
	import flash.utils.ByteArray;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import deng.fzip.FZipEvent;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylichenko
	 * 
	 */
	public class Source
	{
		public static var instance:Source;
		
		// Архив игровых ресурсов
		[Embed(source = "/../assets/assets.zip",  mimeType="application/octet-stream")]
		public static var Assets:Class;		
		
		public static var assets:FZip;
		
		private var _fileName:String;
		
		private var fileInZip:FZipFile;
		
		// Конструктор
		public function Source(fileName:String = "") 
		{
			if (instance == null)
			{
				assets = new FZip();
				assets.loadBytes(new Assets() as ByteArray);
				
				instance = this;
			}
			
			if (fileName) setSource(fileName);		
		}		
		
		// Установка ресурса
		public function setSource(fileName:String):void
		{
			this.fileName = fileName;

			fileInZip = new FZipFile();
			fileInZip = assets.getFileByName("assets/" + fileName);
		}
		
		// Получить контент ресурса в виде масива байтов
		public function getSource():ByteArray
		{
			if (fileInZip != null)
			{
				return fileInZip.content;
			}
			
			return null;
		}		
		
		// Имя файла ресурса
		public function get fileName():String 
		{
			return _fileName;
		}
		
		public function set fileName(value:String):void 
		{
			_fileName = value;
		}
		
	}

}