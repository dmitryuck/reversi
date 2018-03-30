package game.core 
{
	import flash.geom.Point;
	
	import game.utils.Geom;
	
	import com.flashdynamix.motion.Tweensy;
	import com.flashdynamix.motion.TweensySequence;
	import com.flashdynamix.motion.TweensyTimeline;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylichenko
	 */
	
	public class Tween 
	{
		public var tween:TweensySequence;
		
		public var target:GameObject;
		
		public function Tween()
		{
			
		}
		
		// Установка целевого игрового обьекта
		public function setTarget(target:GameObject)
		{
			this.target = target;
		}
		
		// Движение обьекта		
		public function moveTo(position:Point, duration:Number = 1, ease:Function = null, autoRotation:Boolean = false, onComplete:Function = null, ...nextPosition):void
		{			
			if (!tween)
			{
				tween = new TweensySequence();
			} else {
				tween.dispose();
				tween = null;
				tween = new TweensySequence();
			}			
			
			if (nextPosition.length == 0) tween.push(target, { x:position.x, y:position.y, rotation:autoRotation ? Geom.rotateToPoint(target.rotation, target.position, position) : 0 }, duration, ease, 0, 0, null, onComplete);
			else
			{
				var rotation0:Number = autoRotation ? Geom.rotateToPoint(target.rotation, target.position, position) : 0;
				tween.push(this, { x:position.x, y:position.y, rotation:rotation0 }, duration, ease);
				
				var positionLength:int = nextPosition.length;
				
				var rotation:Array = new Array();
				
				for (var i:int = 0; i < positionLength; i++)
				{
					rotation[i] = autoRotation ? Geom.rotateToPoint(i == 0 ? rotation0 : rotation[i - 1], i > 0 ? nextPosition[i - 1] : position, nextPosition[i]) : 0;
					
					if (i < positionLength - 1)
					{
						tween.push(target, { x:nextPosition[i].x, y:nextPosition[i].y, rotation:rotation[i] }, duration, ease);				
					}
					else if (i == positionLength - 1)
					{
						tween.push(target, { x:nextPosition[i].x, y:nextPosition[i].y, rotation:rotation[i] }, duration, ease, 0, 0, null, onComplete);					
					}
				}
			}
			
			tween.start();
		}
		
		// Остановить движение обьекта
		public function stopMove():void
		{
			if (tween) tween.stop();
		}
		
		// Поставить на паузу движение
		public function pauseMove():void
		{
			if (tween) tween.pause();
		}
		
		// Продолжить преостановленное движение
		public function resumeMove():void
		{
			if (tween && tween.paused) tween.resume();
		}
		
	}

}