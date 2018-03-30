package game.user 
{
	import flash.geom.Point;
	
	import game.core.Audio;
	
	import game.ui.UI;
	import game.ui.Window;
	import game.ui.Button;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylichenko
	 */
	public class Menu 
	{
		
		public function Menu() 
		{
			var menuWnd:Window = UI.loadWindow(new Point(), "menu_wnd", null, "interface/menu_wnd.png");
			menuWnd.addComponent(new Point(680, 380), "btn_start", new Button("interface/btn_start_64.png", "interface/btn_start_64_down.png", onStartClick));
		
			function onStartClick():void
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				Game.startGame();
			}
		}		
	}
}