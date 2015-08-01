package net.MultiCoreServer.util
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class Stats extends Sprite
	{
		
		private var StatDisplay:TextField;
		private var DisplayFormat:TextFormat;
		
		public var ConnectionNumber:int;
		
		
		public function Stats()
		{
			super();
			StatDisplay = new TextField();
			DisplayFormat = new TextFormat( null , 36 , 0x000000 );
			StatDisplay.setTextFormat( DisplayFormat);
			ConnectionNumber = new int();
			
			StatDisplay.type = TextFieldType.DYNAMIC;
			StatDisplay.selectable = false;
			StatDisplay.autoSize = TextFieldAutoSize.LEFT;
			StatDisplay.textColor = 0x000000;
			StatDisplay.backgroundColor = 0xFFFFFF;

			addChild( StatDisplay );
		}
		
		public function updateDisplay(  ):void
		{
			StatDisplay.text =
				"Number of Connections: " + ConnectionNumber +"\n" +
				"Total Memory: " + System.privateMemory + "\n" +
				"Free Memory: " + System.freeMemory + "\n" +
				"Memory Used: " + System.freeMemory / System.privateMemory + "\n";
		}
		
	}
}