package game.core 
{
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.DisplayObject;
	import starling.textures.Texture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	
	import flash.events.ProgressEvent;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import game.events.ObjectEvent;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylichenko
	 */
	public class PreObject extends Sprite
	{
		public var displayObject:Image;
		
		private var _fileName:String;
		public var source:Source;
		
		private var loader:Loader;	
		
		public function PreObject(fileName:String) 
		{
			if(fileName != null)
			{
				this.fileName = fileName;
				
				source = new Source(fileName);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
		}
		
		// События связанные с обьектом
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			
			addEventListener(ObjectEvent.OBJECT_LOADED, onLoaded);
			
			if (fileName != null)
			{
				loadDisplayObject();
			} else {
				dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_LOADED));
			}
		}
		
		// Апдейт обьекта
		protected function onUpdate(e:Event):void { }
		
		// Обьект загружен
		protected function onLoaded(e:ObjectEvent):void
		{
			removeEventListener(ObjectEvent.OBJECT_LOADED, onLoaded);
			addListeners();
		}
		
		// Обьект удален
		protected function onDestroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeListeners();
		}
		
		// Добавление слушателей событий
		protected function addListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		// Удаление слушателей событий
		protected function removeListeners():void
		{
			removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		// Отобразить обьект ресурса
		protected function loadDisplayObject():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onDisplayObjectLoaded);
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onDisplayObjectProgress);
			
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderContext.allowCodeImport = true;			
				
			loader.loadBytes(source.getSource(), loaderContext);
		}
		
		// Прцесс загрузки обьекта отображения
		//private function onDisplayObjectProgress(e:ProgressEvent):void {}
		
		// Обьект отображения загружен
		private function onDisplayObjectLoaded(e:flash.events.Event):void
		{	
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDisplayObjectLoaded);
			
			// Если тело меняет ресурс, то удалить тело и перерисовать новое
			if (displayObject != null) removeChild(displayObject);
			
			var dispObj:Bitmap = e.target.content as Bitmap;

			var bitmapData:BitmapData = new BitmapData(dispObj.width, dispObj.height, true, 0);
			bitmapData.draw(dispObj);
			
			var tex:Texture = Texture.fromBitmapData(bitmapData, false, false);
			
			displayObject = new Image(tex);
			addChildAt(displayObject, 0);
			
			dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_LOADED));
		}
		
		// Файлнейм ресурса
		public function get fileName():String
		{
			return _fileName;
		}
		
		// Установка файла ресурса
		public function set fileName(name:String):void
		{
			_fileName = name;
			
			setSource(name);
		}
		
		// Установить новый ресурс отображения для обьекта displayObject
		public function setSource(fileName:String):void
		{
			if (source != null)
			{
				source.setSource(fileName);
			} else {
				source = new Source(fileName);	
			}
			
			loadDisplayObject();
		}
	}
}