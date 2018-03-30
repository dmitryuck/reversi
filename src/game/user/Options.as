package game.user 
{
	import flash.geom.Point;
	
	import game.core.GameObject;
	import game.core.Audio;
	import game.core.Scene;
	
	import game.ui.Component;
	import game.ui.Window;
	import game.ui.Button;
	import game.ui.UI;
	import game.ui.Text;	
	
	/**
	 * ...
	 * @author Dmitriy Mihaylichenko
	 */
	public class Options 
	{
		
		public function Options() 
		{
			var colWnd:Window = UI.loadWindow(new Point(250, 80), "col_wnd", null, "interface/col_wnd.png");
			colWnd.addComponent(new Point(140, 30), "znak", new Component("textures/znak.png"));
			
			var btnWhite:Component = colWnd.addComponent(new Point(50, 30), "btn_white", new Button("textures/white.png", null, onWhiteClick));
			var btnBlack:Component = colWnd.addComponent(new Point(200, 30), "btn_black", new Button("textures/black.png", null, onBlackClick));

			var btnLevel:Button = colWnd.addComponent(new Point(40, 96), "btn_level", new Button("textures/btn_easy.png", "textures/btn_hard.png", onLevelClick)) as Button;
			btnLevel.buttonType = Button.BUTTON_TYPE_CHECK;
			
			colWnd.addComponent(new Point(10, 140), "bot_text", new Text("Play with: ", { color:Config.getVal("textColor").toString(), fontFamily:Config.getVal("fontFamily").toString(), fontSize:int(Config.getVal("labFontSize")), width:int(Config.getVal("labTextWidth")), height:int(Config.getVal("labTextHeight")) }));
			var btnRobo:Button = colWnd.addComponent(new Point(180, 100), "btn_robo", new Button("textures/robo_on.png", "textures/robo_off.png", onRoboClick)) as Button;
			btnRobo.buttonType = Button.BUTTON_TYPE_CHECK;
			
			var btnSlot1:Component = colWnd.addComponent(new Point(15, 230), "btn_slot_1", new Button("textures/slot_1.png", null, onSlotSelectClick1));
			var btnSlot2:Component = colWnd.addComponent(new Point(85, 230), "btn_slot_2", new Button("textures/slot_2.png", null, onSlotSelectClick2));
			var btnSlot3:Component = colWnd.addComponent(new Point(155, 230), "btn_slot_3", new Button("textures/slot_3.png", null, onSlotSelectClick3));
			var btnSlot4:Component = colWnd.addComponent(new Point(225, 230), "btn_slot_4", new Button("textures/slot_4.png", null, onSlotSelectClick4));
			
			colWnd.addComponent(new Point(300, 0), "btn_play", new Button("textures/btn_play.png", null, onBtnPlayClick));
			
			var btnVec:Array = [btnSlot1, btnSlot2, btnSlot3, btnSlot4];
			
			btnWhite.addChildComponent(new Component("textures/marker_sel.png"), "marker");
			selSlotBtn(btnSlot1);
			
			// Выбор уровня сложности бота
			function onLevelClick():void
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				Game.levelEasy = !Game.levelEasy;
			}
			
			function selSlotBtn(btn:Component):void
			{
				for each(var currBtn:Component in btnVec)
				{
					var btnSelector:Component = currBtn.getChildComponentByName("ramka");
					
					if (btnSelector != null)
					{
						currBtn.removeChild(btnSelector);
					}
				}
				
				btn.addChildComponent(new Component("textures/slot_ramka.png"), "ramka");
			}
			
			// Нажата кнопка старт
			function onBtnPlayClick():void
			{
				play();
			}
			
			// Выбор стиля слота ном. 1
			function onSlotSelectClick1():void 
			{
				Audio.playSound("sounds/btn_click.mp3");
				Game.slotTex = "slot_1";
				selSlotBtn(btnSlot1);
			}
			
			// Выбор стиля слота ном. 2
			function onSlotSelectClick2():void 
			{
				Audio.playSound("sounds/btn_click.mp3");
				Game.slotTex = "slot_2";
				selSlotBtn(btnSlot2);
			}
			
			// Выбор стиля слота ном. 3
			function onSlotSelectClick3():void 
			{
				Audio.playSound("sounds/btn_click.mp3");
				Game.slotTex = "slot_3";
				selSlotBtn(btnSlot3);
			}
			
			// Выбор стиля слота ном. 4
			function onSlotSelectClick4():void 
			{
				Audio.playSound("sounds/btn_click.mp3");
				Game.slotTex = "slot_4";
				selSlotBtn(btnSlot4);
			}
			
			// Игрок пропускает ход
			function onPassClick():void
			{
				if(Game.isPlaying == true)
				{
					Audio.playSound("sounds/propusk.mp3");
					
					if (Game.playWithBot == true)
					{
						Game.playerPass = true;
						
						if (Game.botPass == true)
						{
							Game.gameEnd();
						} else {
							Game.changeProg();
						}
					} else {
						if (Game.playerPass == true && Game.playerPass2 == true)
						{
							Game.gameEnd();							
						} else {							
							Game.changeProg();
						}
					}
				}
			}
			
			// Игра с ботом/без
			function onRoboClick():void
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				var colWnd:Window = UI.findWindow("col_wnd");
				var btnBot:Component = colWnd.getComponentByName("btn_robo");
				
				if (Game.playWithBot == true)
				{
					Game.playWithBot = false;
				} else {
					Game.playWithBot = true;
				}
			}
			
			// Добавить маркер на выделенную шашку
			function addBtnMarker(btn:Component):void
			{
				var marker1:Component = btnWhite.getChildComponentByName("marker");
				var marker2:Component = btnBlack.getChildComponentByName("marker");
				
				if (marker1 != null)
				{
					btnWhite.removeChildComponent(marker1);
				}
				
				if (marker2 != null)
				{
					btnBlack.removeChildComponent(marker2);
				}
				
				btn.addChildComponent(new Component("textures/marker_sel.png"), "marker");
			}
			
			// Игрок выбрал белые шашки
			function onWhiteClick():void
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				Game.playerColor = Config.getVal("colWhite").toString();
				
				addBtnMarker(btnWhite);
			}
			
			// Игрок выбрал черные шашки
			function onBlackClick():void
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				Game.playerColor = Config.getVal("colBlack").toString();
				
				addBtnMarker(btnBlack);
			}
			
			// Начать игру
			function play():void
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				Audio.playMusic("sounds/game_music.mp3", true);
				
				UI.destroyWindow(UI.findWindow("col_wnd"));
				
				var gameWnd:Window = UI.loadWindow(new Point(), "game_wnd", null);					
				gameWnd.addComponent(new Point(80, 320), "btn_pass", new Button("textures/btn_pass.png", null, onPassClick));
				gameWnd.addComponent(new Point(20, 70), "img_checks", new Component("textures/img_checks.png"));
				gameWnd.addComponent(new Point(50, 200), "img_black", new Component("textures/black.png"));
				gameWnd.addComponent(new Point(150, 200), "img_white", new Component("textures/white.png"));
				gameWnd.addComponent(new Point(40, 60), "check_num", new Text("        " + int(Config.getVal("startCheckNum")), { color:Config.getVal("textColor").toString(), fontFamily:Config.getVal("fontFamily").toString(), fontSize:int(Config.getVal("labFontSize")), width:int(Config.getVal("labTextWidth")), height:int(Config.getVal("labTextHeight")) }));
				gameWnd.addComponent(new Point(0, 220), "black_num", new Text(Game._blackNum.toString(), { color:Config.getVal("textColor").toString(), fontFamily:Config.getVal("fontFamily").toString(), fontSize:int(Config.getVal("labFontSize")), width:int(Config.getVal("labTextWidth")), height:int(Config.getVal("labTextHeight")) }));
				gameWnd.addComponent(new Point(100, 220), "white_num", new Text(Game._whiteNum.toString(), { color:Config.getVal("textColor").toString(), fontFamily:Config.getVal("fontFamily").toString(), fontSize:int(Config.getVal("labFontSize")), width:int(Config.getVal("labTextWidth")), height:int(Config.getVal("labTextHeight")) }));
				
				Game.slotsArr = new Vector.<GameObject>();
				
				Game.currProg = Game.playerColor;
				
				Game.genSlots();			
				Game.genFigures();
				
				Game.placeObj = Scene.createObject(new Point( -1000, -1000), null, "textures/place_ok.png", "place");
				
				Game.isPlaying = true;
			}
		}		
	}
}