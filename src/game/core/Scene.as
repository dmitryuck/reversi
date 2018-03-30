package game.core 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	import game.events.SceneEvent;
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class Scene extends Sprite
	{
		public static var scene:Scene;
		
		public var source:Source;

		public var layer:Sprite;
		
		public var gameObjects:Vector.<GameObject>;
		
		public var fileName:String;
		
		public function Scene() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);

			source = new Source();
			
			gameObjects = new Vector.<GameObject>;
			
			layer = new Sprite();
			layer.name = "layer";
			
			addChild(layer);
		}
		
		// Имя текущей сцены
		public static function getCurrentScene():String
		{
			return scene.name;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// События связанные со сценой
		private function onAddedToStage(e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
			
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_LOADED));
		}
		
		// Сцена загружена
		protected function onSceneLoaded(e:SceneEvent):void
		{  
			removeEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		// Сцена удалена
		protected function onDestroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeEventListener(Event.ENTER_FRAME, onUpdate);
		}		
		
		// Апдейт сцены
		protected function onUpdate(e:Event):void {}		

		// Очистка сцены
		public static function emptyScene():void
		{
			for each (var gameObject:GameObject in scene.gameObjects)
			{
				if (gameObject)
				{
					destroyObject(gameObject);
					gameObject = null;
				}
			}			
			
			scene.layer.removeChildren();		
		}		
		
		// Создать обьект на сцене
		public static function createObject(position:Point,
											type:Class = null,
											fileName:String = null,
											name:String = null,
											tag:String = null):GameObject
		{			
			var gameObject:GameObject = new (type ? type : GameObject)(fileName, name, tag);			
		
			scene.gameObjects.push(gameObject);
			
			scene.layer.addChild(gameObject);
			
			gameObject.position = position;
			
			return gameObject;
		}
		
		// Удаоение обьекта
		public static function destroyObject(object:GameObject):void
		{
			if (object != null)
			{
				object.deactivate();
			
				var i:int = 0;
				
				for each(var currentObject:GameObject in scene.gameObjects)
				{
					if (currentObject == object) 
					{
						scene.gameObjects[i] = null;
						break;
					}
					i++;
				}
			
				object.parent.removeChild(object);

				object = null;
			}
		}
		
		// Удаление обьектов
		public static function destroyObjects(...objects):void
		{
			if (objects[0] is Vector.<GameObject>)
			{
				for each (var objectInVector:GameObject in objects[0])
				{
					if (objectInVector) destroyObject(objectInVector);
				}
			} else
			if (objects[0] is GameObject) 
			{			
				for each (var object:GameObject in objects)
				{
					if (object) destroyObject(object);
				}
			}
		}
		
		// Получить обьект по имени
		public static function getObjectByName(name:String):GameObject
		{
			if (name != null)
			{
				for each(var currentObject:GameObject in scene.gameObjects)
				{
					if (currentObject && currentObject.name == name)
						return currentObject;				
				}
			}
			
			return null;
		}
		
		// Получить обьект по тагу
		public static function getObjectByTag(tag:String):GameObject
		{
			if (tag != null)
			{
				for each(var currentObject:GameObject in scene.gameObjects)
				{
					if (currentObject && currentObject.tag == tag)
						return currentObject;				
				}
			}
			
			return null;
		}
		
		// Получить обьекты по тагу
		public static function getTaggedObjects(tag:String):Vector.<GameObject>
		{
			if (tag != null)
			{
				var vector:Vector.<GameObject> = new Vector.<GameObject>;
				
				for each (var currentObject:GameObject in scene.gameObjects)
				{
					if (currentObject && currentObject.tag == tag) vector.push(currentObject);
				}
			}
			
			return vector.length > 0 ? vector : null;
		}
	}
}