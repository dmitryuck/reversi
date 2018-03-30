package game.user 
{
	import flash.utils.*;
	
	import flash.geom.Point;
	
	import game.core.Audio;
	import game.core.Scene;
	import game.core.GameObject;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 */
	public class Bot 
	{
		// ходит бот
		public static function botProg():void
		{
			if (Game.completed == true) return;
			
			var emptySlots:Vector.<GameObject> = new Vector.<GameObject>();
			
			for (var a:int = 0; a < Game.slotsArr.length; a++)
			{
				var currSlot:GameObject = GameObject(Game.slotsArr[a]);
				
				if (currSlot.tag == Config.getVal("slotEmpty").toString())
				{
					emptySlots.push(currSlot);
				}
			}
			
			var dict:Dictionary = new Dictionary();
			
			for each(var currSlot:GameObject in emptySlots)
			{
				var combCount:int = ObjectCombinator.getCombObjs(Game.currProg, currSlot.name).length;
				dict[currSlot] = combCount;
			}
			
			var maxCombSlot:GameObject = null;
			
			var combCounter:int = 0;
			
			for (var key in dict)
			{
				if (dict[key] > combCounter)
				{
					combCounter = dict[key];
					
					maxCombSlot = key;
				}
			}
			
			// У бота нет ходов
			if (maxCombSlot == null) {				
				Game.botPass = true;
				
				if (Game.playerPass == false)
				{
					Game.isPlaying = true;
					
					Audio.playSound("sounds/propusk.mp3");
				
					Game.changeProg();
					
					return;
				} else {
					Game.gameEnd();
					
					return;
				}			
			}
			
			if (Game.playerPass == true)
			{				
				Game.playerPass = false;
			}
			
			var col:int = ObjectCombinator.getObjCol(maxCombSlot.name);
			var row:int = ObjectCombinator.getObjRow(maxCombSlot.name);
			
			var shashka:GameObject = Scene.createObject(new Point(40, 80), null, "textures/" + Game.currProg + ".png", Config.getVal("objPref").toString() + row + "_" + col, Game.currProg); 
			
			maxCombSlot.tag = Config.getVal("slotBusy").toString();
			
			Game.placeObj.fileName = "textures/place_ok.png";
			Game.placeObj.position = new Point(0, 0);			
			maxCombSlot.addChild(Game.placeObj);
			
			Game.combObjs = ObjectCombinator.getCombObjs(Game.currProg, maxCombSlot.name);
			
			Game.addMarkers();
			
			setTimeout(delayCall, 2000, shashka, maxCombSlot.position);
			
			function delayCall(obj:GameObject, position:Point):void
			{
				Game.tween.setTarget(obj);
				Game.tween.moveTo(position, 1, null, false, onPlace);
				
				Game.hidePlace();
				
				Audio.playSound("sounds/place_ok.mp3");
				
				function onPlace()
				{
					Game.clearMarkers();
				
					Game.remCheck();
				
					Game.reversType();
				
					Game.changeProg();
				
					Game.combObjs.length = 0;
				
					Game.isPlaying = true;
				}
			}
		}		
	}
}