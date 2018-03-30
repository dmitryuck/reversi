package game.core 
{
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import flash.geom.Point;
	
	import game.utils.Geom;	
	import game.events.ObjectEvent;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */	
	public class GameObject extends PreObject
	{
		public var tag:String;	
		public var type:String;
		
		public static var hovObj:GameObject;
		
		private var _position:Point;
		
		private var active:Boolean;
		private var _relativeCenter:Boolean;
		
		public var onClick:Function;
		public var onEnter:Function;
		public var onLeave:Function;
		
		// Констр
		public function GameObject(fileName:String = "", name:String = "", tag:String = "") 
		{
			super(fileName);
			
			this.name = name;
			this.tag = tag;
			
			position = new Point();
		}
			
		// Нажатие на обьект
		protected function onObjectTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			
			if (touch != null)
			{
				if (touch.phase == TouchPhase.HOVER) {
					if (hovObj != e.currentTarget)
					{						
						if (hovObj != null && onLeave != null)
						{
							var event:ObjectEvent = new ObjectEvent(ObjectEvent.MOUSE_LEAVE);
							event.params.target = this;
							
							dispatchEvent(event);
							
							if(onLeave != null){
								onLeave();
							}
						}
						
						hovObj = e.currentTarget as GameObject;
						
						var event:ObjectEvent = new ObjectEvent(ObjectEvent.MOUSE_ENTER);
						event.params.target = this;
						
						dispatchEvent(event);
						
						if (onEnter != null) {
							onEnter();
						}
					}
				}
				
				if (touch.phase == TouchPhase.ENDED)
				{			
					//if (enabled)
					//{
						var event:ObjectEvent = new ObjectEvent(ObjectEvent.OBJECT_CLICK);
						event.params.target = this;
						
						dispatchEvent(event);
						
						if(onClick != null)
						{
							onClick();		
						}
					//}
				}
			}
		}
		
		// Обьект загружен
		protected override function onLoaded(e:ObjectEvent):void
		{
			super.onLoaded(e);
			
			addListeners();
		}
		
		// Добавление слушателей к обьекту
		protected override function addListeners():void
		{
			super.addListeners();
			
			addEventListener(TouchEvent.TOUCH, onObjectTouch);
		}
		
		// Удаление слушателей с обьекта
		protected override function removeListeners():void
		{
			super.removeListeners();
			
			removeEventListener(TouchEvent.TOUCH, onObjectTouch);
		}
		
		// Установка пивота обьекта
		public function setCenter():void
		{
			displayObject.x = displayObject.width / 2 * ( -1);
			displayObject.y = displayObject.height / 2 * ( -1);
		}
		
		public function setCorner():void
		{
			displayObject.x = 0;
			displayObject.y = 0;
		}			
		
		// Сделать обьект верхним
		public function sendToFront():void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		// Child - добавление удаление, показ скрытие		
		public function addChildObject(position:Point,
										type:Class = null,													   
										fileName:String = "",													   
										name:String = ""):GameObject
		{
			var child:GameObject = new (type ? type : GameObject)(fileName, name);			
			
			this.addChild(child);
			
			child.position = position;
			
			return child;
		}
		
		// Удалить дочерный обьект
		public function removeChildObject(child:GameObject):void
		{			
			child.parent.removeChild(child);
			
			child = null;
		}
		
		// Получить дочерный обьект по имени
		public function getChildObjectByName(name:String):GameObject
		{
			if (name != null)
			{
				return GameObject(this.getChildByName(name));
			}
			
			return null;
		}
		
		// Показать дочерный обьект
		public function showChild(child:GameObject):void
		{
			if (child && !child.visible) child.visible = true;
		}
		
		// Спрятать дочерный обьект
		public function hideChild(child:GameObject):void
		{
			if (child && child.visible) child.visible = false;
		}		
		
		// Показать обьект	
		public function showObject():void
		{
			if (displayObject && !displayObject.visible) displayObject.visible = true;
		}
		
		//  Скрыть обьект
		public function hideObject():void
		{
			if (displayObject && displayObject.visible) displayObject.visible = false;
		}
		
		// Изменение позиции обьекта
		public function get position():Point 
		{
			_position.x = this.x;
			_position.y = this.y;
			
			return _position;
		}
		
		public function set position(value:Point):void 
		{
			this.x = value.x;
			this.y = value.y;
			
			_position = value;			
		}
		
		// Активировать обьект
		public function activate():void
		{
			if (!isActive())
			{
				active = true;				
				loadDisplayObject();
				addListeners();
			}
		}
		
		// Деактивировать обьект
		public function deactivate():void
		{
			if (isActive())
			{
				active = false;
				
				removeListeners();				
				removeChildren();
				
				displayObject = null;
			}
		}
		
		// Проверка активен ли обьект
		public function isActive():Boolean
		{
			return active;
		}		
	}
}