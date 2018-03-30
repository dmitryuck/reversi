package
{	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import flash.geom.Point;
	import flash.utils.*;
	
	import game.core.Core;
	import game.core.Tween;
	import game.core.Audio;
	import game.core.Scene;
	import game.core.GameObject;	
	
	import game.ui.UI;
	import game.ui.Text;
	import game.ui.Button;
	import game.ui.Component;
	import game.ui.Window;
	
	import game.events.ObjectEvent;
	
	import game.user.End;
	import game.user.ObjectCombinator;
	import game.user.Slot;
	import game.user.Bot;
	import game.user.Menu;
	import game.user.Options;	

	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 * e-mail dmitriy.mihaylichenko@gmail.com
	 */	

	public class Game extends Core
	{
		public static var combObjs:Vector.<GameObject>;
		
		public static var currProg:String;
		public static var playerColor:String;		
		
		public static var _currCheckNum:int;
		
		public static var _whiteNum:int;
		public static var _blackNum:int;
		
		public var canPlace:Boolean;
		public static var placeObj:GameObject;
		
		public static var slotsArr:Vector.<GameObject>;
		
		public static var slotTex:String;
		
		public static var playWithBot:Boolean;
		public static var levelEasy:Boolean;

		public static var isPlaying:Boolean;
		public static var completed:Boolean;
		
		public static var tween:Tween;
		
		public static var playerPass:Boolean;
		public static var playerPass2:Boolean;
		public static var botPass:Boolean;
		
		// Конструкт
		public function Game()
		{
			tween = new Tween();
			
			onReady = function ()
			{
				var conf:Config = new Config();
				conf.onLoaded = function () {					
					loadMenu();
				};
				
				conf.loadConfig("config.txt");
			}
			
			super();
		}
		
		
		// Загрузка игрового меню
		private function loadMenu():void
		{			
			var menu:Menu = new Menu();
 		}
		
		// Количество белых шашек
		public static function get whiteNum():int
		{
			return _whiteNum;
		}
		
		public static function set whiteNum(val:int):void
		{
			_whiteNum = val;
			
			var gameWnd:Window = UI.findWindow("game_wnd");
			
			if (gameWnd != null)
			{			
				var text:Text = Text(gameWnd.getComponentByName("white_num"));
				
				var value:String = (val >= 0 ? val.toString() : "0");
				
				if (text != null)
				{
					text.setText(value);
				}
			}
		}
		
		// Количество черных шашек
		public static function get blackNum():int
		{
			return _blackNum;
		}
		
		public static function set blackNum(val:int):void
		{
			_blackNum = val;
			
			var gameWnd:Window = UI.findWindow("game_wnd");
			
			if (gameWnd != null)
			{			
				var text:Text = Text(gameWnd.getComponentByName("black_num"));
				
				var value:String = (val >= 0 ? val.toString() : "0");
				
				if (text != null)
				{
					text.setText(value);
				}
			}
		}
		
		// Уменьшить количество запасных шашек
		public static function remCheck():void
		{
			currCheckNum --;
			
			if (currCheckNum <= 0)
			{
				gameEnd();
			}
		}
		
		// Текущее количество запасных шашек
		public static function get currCheckNum():int
		{
			return _currCheckNum;
		}
		
		public static function set currCheckNum(val:int):void
		{
			_currCheckNum = val;
			
			var gameWnd:Window = UI.findWindow("game_wnd");
			
			if (gameWnd != null)
			{			
				var checkText:Text = Text(gameWnd.getComponentByName("check_num"));
				
				var checkVal:String = (val >= 0 ? val.toString() : "0");
				
				if (checkText != null)
				{
					checkText.setText("        " + checkVal);
				}
			}
		}
		
		// Начало игры
		public static function startGame():void
		{
			UI.destroyWindow(UI.findWindow("menu_wnd"));
			
			Scene.createObject(new Point(), null, "interface/game_bg.png", "bg");
			
			combObjs = new Vector.<GameObject>();
			
			_currCheckNum = int(Config.getVal("startCheckNum"));
			
			_whiteNum = 2;
			_blackNum = 2;
			
			slotTex = "slot_1";
			
			levelEasy = true;
			
			playerColor = Config.getVal("colWhite").toString();
			
			playerPass = false;
			botPass = false;
			
			completed = false;
			playWithBot = true;
			
			var optionsWnd:Options = new Options();
		}
		
		// Смена ходячих шашек
		public static function changeProg():void
		{
			var isPlayerProg:Boolean = (currProg == playerColor ? true : false);			
			
			if (currProg == Config.getVal("colBlack").toString())
			{
				currProg = Config.getVal("colWhite").toString();
			} else {
				currProg = Config.getVal("colBlack").toString();;
			}
			
			if (playWithBot == true)
			{
				if (isPlayerProg == true)
				{
					isPlaying = false;
					
					setTimeout(Bot.botProg, 2000);
				} else {
					isPlaying = true;
				}
			} else {
				isPlaying = true;				
			}
		}		
		
		// Изменить тип шашки
		public static function reversType():void
		{
			for each(var currObj:GameObject in combObjs)
			{
				if (currObj.tag == Config.getVal("colBlack").toString())
				{
					currObj.tag = Config.getVal("colWhite").toString();
					currObj.fileName = "textures/white.png";
				} else {
					currObj.tag = Config.getVal("colBlack").toString();
					currObj.fileName = "textures/black.png";
				}
			}
			
			var combCount:int = combObjs.length;
			
			if (currProg == Config.getVal("colWhite").toString())
			{
				whiteNum += 1;
				
				whiteNum += combCount;
				blackNum -= combCount;
			} else {
				blackNum += 1;
				
				whiteNum -= combCount;
				blackNum += combCount;
			}
			
			if (whiteNum <= 0 || blackNum <= 0)
			{
				gameEnd();
			}
		}
		
		// Уровень завершен
		public static function gameEnd():void
		{
			isPlaying = false;
			
			completed = true;
			
			UI.destroyWindow(UI.findWindow("game_wnd"));
			
			Audio.stopMusic();
			
			// Кто же выиграл?
			if (whiteNum > blackNum)
			{
				if (playerColor == Config.getVal("colWhite").toString())
				{
					playerWin();
				} else {
					playerLose();
				}
			} else {				
				if (playerColor == Config.getVal("colWhite").toString())
				{
					playerLose();
				} else {
					playerWin();
				}
			}
			
			var message:String;
			
			function playerWin():void
			{
				Audio.playMusic("sounds/win.mp3");
				
				if (playWithBot == true)
				{
					message = "You Win!!!";
				} else {
					message = playerColor+" Win!!!";
				}
			}
			
			function playerLose():void
			{
				Audio.playMusic("sounds/over.mp3");
				
				message = "Game Over...";				
			}
			
			var endWnd:End = new End(message);
		}
		
		// Сгенерировать слоты
		public static function genSlots():void
		{
			for (var r:int = 0; r < int(Config.getVal("rowMaxCnt")); r++) 
			{
				for (var c:int = 0; c < int(Config.getVal("colMaxCnt")); c++)
				{
					var obj:GameObject = Scene.createObject(new Point(int(Config.getVal("startX"))+(int(Config.getVal("figureSize"))*c), int(Config.getVal("startY"))+(int(Config.getVal("figureSize"))*r)), Slot, "textures/"+slotTex+".png", Config.getVal("sltPref").toString()+r+"_"+c, Config.getVal("slotEmpty").toString());
					
					slotsArr.push(obj);
				}
			}
		}
		
		// Сгенерировать фигуры
		public static function genFigures():void
		{
			var startFig:Object = { "S_3_3":Config.getVal("colWhite").toString(), "S_4_4":Config.getVal("colWhite").toString(), "S_4_3":Config.getVal("colBlack").toString(), "S_3_4":Config.getVal("colBlack").toString() };
			
			for (var currKey:String in startFig)
			{
				var col:int = ObjectCombinator.getObjCol(currKey);
				var row:int = ObjectCombinator.getObjRow(currKey);
				
				var slot:GameObject = Scene.getObjectByName(currKey);
				slot.tag = Config.getVal("slotBusy").toString();
				
				var obj:GameObject = Scene.createObject(new Point(int(Config.getVal("startX"))+(int(Config.getVal("figureSize"))*col), int(Config.getVal("startY"))+(int(Config.getVal("figureSize"))*row)), null, "textures/"+startFig[currKey]+".png", Config.getVal("objPref").toString()+row+"_"+col, startFig[currKey]);
			}
		}
		
		// Спрятать подсветку
		public static function hidePlace():void
		{
			placeObj.position = new Point(-1000, -1000);
		}
		
		// Добавить маркеры к обьектам
		public static function addMarkers():void
		{
			for each(var currCombObj:GameObject in combObjs)
			{
				currCombObj.addChildObject(new Point(), null, "textures/marker.png", "marker");
			}
		}
		
		// Удалить маркеры с обьектов
		public static function clearMarkers():void 
		{
			for each(var currCombObj:GameObject in combObjs)
			{
				var marker:GameObject = currCombObj.getChildObjectByName("marker");
				
				if (marker != null)
				{
					currCombObj.removeChildObject(marker);
				}
			}
		}
	}	
}