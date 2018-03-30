package game.user 
{
	import game.core.GameObject;
	import game.core.Scene;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 */
	public class ObjectCombinator 
	{
		
		public function ObjectCombinator() 
		{
			
		}
		
		// Подсчет рядка
		public static function getObjRow(objName:String):int
		{
			return getRowColNumber(objName, "row");
		}
		
		// Подсчет колонки
		public static function getObjCol(objName:String):int
		{			
			return getRowColNumber(objName, "col");
		}
		
		// Взять выше
		public function getUpObj(objName:String):String
		{
			if (!objName) return "";
			
			var row:int = getObjRow(objName) - 1;
			var col:int = getObjCol(objName);
			
			// Если в крайнем положении соседняя равна null
			if (row < 0 || col < 0) return "";
			
			return String(Config.getVal("objPref").toString() + row + "_" + col);
		}
		
		// Взять ниже
		public function getDownObj(objName:String):String
		{
			if (!objName) return "";			
			
			var row:int = getObjRow(objName) + 1;
			var col:int = getObjCol(objName);
			
			// Если в крайнем положении соседняя равна null
			if (row < 0 || col < 0) return "";
			
			return String(Config.getVal("objPref").toString() + row + "_" + col);
		}
		
		// Взять левее
		public function getLeftObj(objName:String):String
		{
			if (!objName) return "";			
			
			var row:int = getObjRow(objName);
			var col:int = getObjCol(objName) - 1;
			
			// Если в крайнем положении соседняя равна null
			if (row < 0 || col < 0) return "";
			
			return String(Config.getVal("objPref").toString() + row + "_" + col);
		}
		
		// Взять правее
		public function getRightObj(objName:String):String
		{	
			if (!objName) return "";
			
			var row:int = getObjRow(objName);
			var col:int = getObjCol(objName) + 1;
			
			// Если в крайнем положении соседняя равна null
			if (row < 0 || col < 0) return "";
			
			return String(Config.getVal("objPref").toString() + row + "_" + col);
		}
		
		// Скомбинированные обьекты
		public static function getCombObjs(tag:String, pos:String):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			var combObjs:Vector.<GameObject> = new Vector.<GameObject>();
			
			combObjsTmp = getCombLeft(tag, pos);			
			for (var a:int = 0; a < combObjsTmp.length; a++)
			{
				combObjs.push(combObjsTmp[a]);
			}
			
			combObjsTmp = getCombRight(tag, pos);			
			for (var a:int = 0; a < combObjsTmp.length; a++)
			{
				combObjs.push(combObjsTmp[a]);
			}
			
			combObjsTmp = getCombUp(tag, pos);			
			for (var a:int = 0; a < combObjsTmp.length; a++)
			{
				combObjs.push(combObjsTmp[a]);
			}
			
			combObjsTmp = getCombDown(tag, pos);			
			for (var a:int = 0; a < combObjsTmp.length; a++)
			{
				combObjs.push(combObjsTmp[a]);
			}
			
			// Комбинации по диагонале
			combObjsTmp = getDiagLeftUpComb(tag, pos);			
			for (var a:int = 0; a < combObjsTmp.length; a++)
			{
				combObjs.push(combObjsTmp[a]);
			}
			
			combObjsTmp = getDiagLeftDwComb(tag, pos);			
			for (var a:int = 0; a < combObjsTmp.length; a++)
			{
				combObjs.push(combObjsTmp[a]);
			}
			
			combObjsTmp = getDiagRightUpComb(tag, pos);			
			for (var a:int = 0; a < combObjsTmp.length; a++)
			{
				combObjs.push(combObjsTmp[a]);
			}
			
			combObjsTmp = getDiagRightDwComb(tag, pos);			
			for (var a:int = 0; a < combObjsTmp.length; a++)
			{
				combObjs.push(combObjsTmp[a]);
			}
			
			return combObjs;
		}
		
		// Скомбинированные влево
		public static function getCombLeft(tag:String, pos:String):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(pos);
			var col:int = getObjCol(pos);
			
			for (var i:int = col-1; i >= 0; i--)
			{
				var currObj:GameObject = Scene.getObjectByName(Config.getVal("objPref").toString() + row + "_" + i);
				
				if (currObj != null)
				{					
					if (currObj.tag != tag)
					{
						if(i > 0)
						{
							combObjsTmp.push(currObj);
						} else {
							combObjsTmp.length = 0;
							break;
						}
					} else {
						break;
					}
				} else {
					combObjsTmp.length = 0;
					break;
				}
			}
			
			return combObjsTmp;
		}
		
		// Скомбинированные справа
		public static function getCombRight(tag:String, pos:String):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(pos);
			var col:int = getObjCol(pos);
			
			for (var i:int = col+1; i < int(Config.getVal("rowMaxCnt")); i++)
			{
				var currObj:GameObject = Scene.getObjectByName(Config.getVal("objPref").toString() + row + "_" + i);
				
				if (currObj != null)
				{
					if (currObj.tag != tag)					
					{
						if (i < int(Config.getVal("rowMaxCnt")) - 1)
						{
							combObjsTmp.push(currObj);
						} else {
							combObjsTmp.length = 0;
							break;
						}
					} else {
						break;
					}
				} else {
					combObjsTmp.length = 0;
					break;
				}
			}
			
			return combObjsTmp;
		}
		
		// Скомбинированные сверху
		public static function getCombUp(tag:String, pos:String):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(pos);
			var col:int = getObjCol(pos);
			
			for (var i:int = row-1; i >= 0; i--)
			{
				var currObj:GameObject = Scene.getObjectByName(Config.getVal("objPref").toString() + i + "_" + col);
				
				if (currObj != null)
				{					
					if (currObj.tag != tag)
					{				
						if (i > 0)
						{
							combObjsTmp.push(currObj);
						} else {
							combObjsTmp.length = 0;
							break;
						}
					} else {
						break;
					}
				} else {
					combObjsTmp.length = 0;
					break;
				}
			}
			
			return combObjsTmp;
		}
		
		//  Скомбинированные снизу
		public static function getCombDown(tag:String, pos:String):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(pos);
			var col:int = getObjCol(pos);
			
			for (var i:int = row+1; i < int(Config.getVal("rowMaxCnt")); i++)
			{
				var currObj:GameObject = Scene.getObjectByName(Config.getVal("objPref").toString() + i + "_" + col);
				
				if (currObj != null)
				{
					if (currObj.tag != tag)
					{
						if (i < int(Config.getVal("rowMaxCnt")) - 1)
						{
							combObjsTmp.push(currObj);
						} else {
							combObjsTmp.length = 0;
							break;
						}
					} else {
						break;
					}
				} else {
					combObjsTmp.length = 0;
					break;
				}
			}
			
			return combObjsTmp;
		}
		
		// Комбинации по диагоналям левый верх
		public static function getDiagLeftUpComb(tag:String, pos:String):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(pos);
			var col:int = getObjCol(pos);
			
			var r:int = row - 1;
			var c:int = col - 1;
			
			while (r >= 0 && c >= 0)
			{
				var currObj:GameObject = Scene.getObjectByName(Config.getVal("objPref").toString() + r + "_" + c);
					
				if (currObj != null)
				{					
					if (currObj.tag != tag)
					{
						if (r > 0 && c > 0)
						{
							combObjsTmp.push(currObj);
						} else {
							combObjsTmp.length = 0;
							break;
						}
					} else {
						break;
					}
				} else {
					combObjsTmp.length = 0;
					break;
				}
				
				r --;
				c --;
			}
			
			return combObjsTmp;
		}
		
		// Комбинации по диагоналям левый низ
		public static function getDiagLeftDwComb(tag:String, pos:String):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(pos);
			var col:int = getObjCol(pos);
			
			var r:int = row + 1;
			var c:int = col - 1;
			
			while (r < int(Config.getVal("rowMaxCnt")) && c >= 0)
			{
				var currObj:GameObject = Scene.getObjectByName(Config.getVal("objPref").toString() + r + "_" + c);
					
				if (currObj != null)
				{
					if (currObj.tag != tag)
					{
						if (r < int(Config.getVal("rowMaxCnt")) - 1 && c > 0)
						{
							combObjsTmp.push(currObj);
						} else {
							combObjsTmp.length = 0;
							break;
						}
					} else {
						break;
					}
				} else {
					combObjsTmp.length = 0;
					break;
				}
				
				r ++;
				c --;
			}
			
			return combObjsTmp;
		}
		
		// Комбинации по диагоналям правый верх
		public static function getDiagRightUpComb(tag:String, pos:String):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(pos);
			var col:int = getObjCol(pos);
			
			var r:int = row - 1;
			var c:int = col + 1;
			
			while (r >= 0 && c < int(Config.getVal("colMaxCnt")))
			{
				var currObj:GameObject = Scene.getObjectByName(Config.getVal("objPref").toString() + r + "_" + c);
					
				if (currObj != null)
				{
					if (currObj.tag != tag)
					{
						if (r > 0 && c < int(Config.getVal("colMaxCnt"))-1)
						{
							combObjsTmp.push(currObj);
						} else {
							combObjsTmp.length = 0;
							break;
						}
					} else {
						break;
					}
				} else {
					combObjsTmp.length = 0;
					break;
				}
				
				r --;
				c ++;
			}
			
			return combObjsTmp;
		}
		
		// Комбинации по диагоналям правый низ
		public static function getDiagRightDwComb(tag:String, pos:String):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(pos);
			var col:int = getObjCol(pos);
			
			var r:int = row + 1;
			var c:int = col + 1;
			
			while (r < int(Config.getVal("rowMaxCnt")) && c < int(Config.getVal("colMaxCnt")))
			{
				var currObj:GameObject = Scene.getObjectByName(Config.getVal("objPref").toString() + r + "_" + c);
				
				if (currObj != null)
				{
					if (currObj.tag != tag)
					{
						if (r < int(Config.getVal("rowMaxCnt"))-1 && c < int(Config.getVal("colMaxCnt"))-1)
						{
							combObjsTmp.push(currObj);
						} else {
							combObjsTmp.length = 0;
							break;
						}
					} else {
						break;
					}
				} else {
					combObjsTmp.length = 0;
					break;
				}
				
				r ++;
				c ++;
			}
			
			return combObjsTmp;
		}
		
		// Определение колонки, рядка в имени
		public static function getRowColNumber(name:String, type:String):int
		{			
			function isNumber(char:String):Boolean
			{
				if (char.charAt(0) == "1" ||
					char.charAt(0) == "2" ||
					char.charAt(0) == "3" ||
					char.charAt(0) == "4" ||
					char.charAt(0) == "5" ||
					char.charAt(0) == "6" ||
					char.charAt(0) == "7" ||
					char.charAt(0) == "8" ||
					char.charAt(0) == "9" ||
					char.charAt(0) == "0")
				{
					return true;
				}
				
				return false;
			}
			
			var numb:int;
			
			for (var n:int = 0; n < name.length; n++)
			{
				if (isNumber(name.charAt(n)) == true)
				{  
					name = name.slice(2, name.length);
					
					if (type == "row")
					{
						if (isNumber(name.charAt(1)))
						{
							numb = int(name.slice(0, 2));
						} else numb = int(name.slice(0, 1));
					} else if (type == "col")
					{
						name = name.slice(name.indexOf("_") + 1, name.length);
						
						if (isNumber(name.charAt(1)))
						{
							numb = int(name.slice(0, 2));
						} else numb = int(name.slice(0, 1));
					}
					
					break;
				}
			}
			
			return numb;
		}
	}
}