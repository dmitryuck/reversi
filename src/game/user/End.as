package game.user 
{
	import flash.geom.Point;
	
	import game.core.Audio;
	import game.core.Scene;
	
	import game.ui.UI;
	import game.ui.Component;
	import game.ui.Button;
	import game.ui.Text;
	import game.ui.Window;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 */
	public class End 
	{
		
		public function End(message:String) 
		{
			var completeWnd:Window = UI.loadWindow(new Point(), "game_end", null, "interface/level_end.png");						
			
			completeWnd.addComponent(new Point(336, 310), "btn_again", new Button("interface/btn_reset_128.png", "interface/btn_reset_128_down.png", onAgainClick));
			
			completeWnd.addComponent(new Point(280, 40), "msg", new Text(message, { color:Config.getVal("textColor").toString(), fontFamily:Config.getVal("fontFamily").toString(), fontSize:int(Config.getVal("msgFontSize")), width:int(Config.getVal("msgTextWidth")), height:int(Config.getVal("msgTextHeight")) }));
			
			completeWnd.addComponent(new Point(320, 200), "img_black", new Component("textures/black.png"));
			completeWnd.addComponent(new Point(430, 200), "img_white", new Component("textures/white.png"));			
			
			completeWnd.addComponent(new Point(220, 210), "black_num", new Text(Game._blackNum.toString(), { color:Config.getVal("textColor").toString(), fontFamily:Config.getVal("fontFamily").toString(), fontSize:int(Config.getVal("labFontSize")), width:int(Config.getVal("labTextWidth")), height:int(Config.getVal("labTextHeight")) }));
			completeWnd.addComponent(new Point(330, 210), "white_num", new Text(Game._whiteNum.toString(), { color:Config.getVal("textColor").toString(), fontFamily:Config.getVal("fontFamily").toString(), fontSize:int(Config.getVal("labFontSize")), width:int(Config.getVal("labTextWidth")), height:int(Config.getVal("labTextHeight")) }));
			
			// Играть снова
			function onAgainClick():void
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				Scene.emptyScene();
				
				Game.isPlaying = true;
				
				UI.destroyWindow(UI.findWindow("game_end"));
				
				Game.startGame();
			}	
		}
	}
}