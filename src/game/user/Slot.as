package game.user 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	import flash.geom.Point;
	import flash.utils.*;
	
	import game.events.ObjectEvent;
	import game.core.GameObject;
	import game.core.Scene;
	import game.core.Audio;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 */
	public class Slot extends GameObject
	{
		
		public function Slot(fileName:String, name:String, tag:String) 
		{
			super(fileName, name, tag);
			
			addEventListener(ObjectEvent.OBJECT_CLICK, onSlotClick);
			
			addEventListener(ObjectEvent.MOUSE_ENTER, onSlotEnter);
			addEventListener(ObjectEvent.MOUSE_LEAVE, onSlotLeave);
		}
		
		// Обработчик нажатия на слот
		private function onSlotClick(e:ObjectEvent):void
		{
			var currSlot:GameObject = e.params.target as GameObject;
			
			if (Game.isPlaying == true)
			{
				var row:int = ObjectCombinator.getObjRow(currSlot.name);
				var col:int = ObjectCombinator.getObjCol(currSlot.name);
				
				if (Game.combObjs.length > 0)
				{
					Game.hidePlace();
					
					var shashka:GameObject = Scene.createObject(new Point(40, 80), null, "textures/" + Game.currProg + ".png", Config.getVal("objPref").toString() + row + "_" + col, Game.currProg);
					currSlot.tag = Config.getVal("slotBusy").toString();					
					
					Game.tween.setTarget(shashka);
					Game.tween.moveTo(currSlot.position);
					
					if (Game.levelEasy == false)
					{
						Game.addMarkers();
					}
					
					Audio.playSound("sounds/place_ok.mp3");
					
					Game.isPlaying = false;
					
					setTimeout(reverse, 2000);
					
					function reverse():void
					{
						Game.isPlaying = true;
						
						Audio.playSound("sounds/reverse.mp3");						
						
						Game.clearMarkers();
						
						Game.reversType();
						
						Game.changeProg();
						
						Game.remCheck();
					}
				} else {
					Audio.playSound("sounds/place_no.mp3");
				}
			}
		}
		
		// Наведено на слот
		private function onSlotEnter(e:ObjectEvent):void
		{
			var currSlot:GameObject = e.params.target as GameObject;
			
			if (Game.isPlaying == true)
			{
				if (Game.levelEasy == true)
				{
					Game.clearMarkers();
				}
				
				Game.combObjs = ObjectCombinator.getCombObjs(Game.currProg, currSlot.name);			
				
				if (Game.combObjs.length > 0)
				{
					Game.placeObj.fileName = "textures/place_ok.png";
					
					if (Game.levelEasy == true)
					{
						Game.addMarkers();
					}
				} else {
					Game.placeObj.fileName = "textures/place_no.png";
				}				
				
				Game.placeObj.position = new Point(0, 0);
				
				currSlot.addChild(Game.placeObj);
			}
		}
		
		// Курсор покинул слот
		private function onSlotLeave(e:ObjectEvent):void
		{
			
		}		
	}
}