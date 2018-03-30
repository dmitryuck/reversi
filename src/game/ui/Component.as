package game.ui 
{
	import game.core.GameObject;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylichenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class Component extends GameObject 
	{
		
		// Конструктор
		public function Component(fileName:String) 
		{			
			super(fileName);
		}		
		
		// Добавить дочерний компонент
		public function addChildComponent(comp:Component, name:String):Component
		{
			addChild(comp);
			
			comp.name = name;
			
			return comp;
		}
		
		// Удалить дочерний компонент
		public function removeChildComponent(comp:Component):void
		{
			this.removeChild(comp);
		}
		
		// Взять дочерний компонент по имени
		public function getChildComponentByName(name:String):Component
		{
			return Component(getChildByName(name));
		}
	}
}