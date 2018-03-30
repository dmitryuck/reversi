package game.core 
{
	import starling.display.Sprite;
	import starling.events.Event;

	import game.events.SceneEvent;
	import game.ui.UI;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylichenko
	 */
	public class Core extends Sprite 
	{		
		public var onReady:Function;
		
		// Конструктор
		public function Core() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		// Добавлен на Stage
		private function onAddedToStage (e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			Scene.scene = new Scene();
			Scene.scene.addEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
			
			UI.ui = new UI();
			
			Display.display = new Display(this);			
			Display.display.addChild(Scene.scene);
			Display.display.addChild(UI.ui);
		}
		
		// Сцена загружена
		private function onSceneLoaded(e:SceneEvent):void
		{
			Scene.scene.removeEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
			
			if (onReady != null)
			{
				onReady();
			}
		}
		
	}

}