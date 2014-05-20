package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Alex Popescu
	 */
	public class Main extends Sprite 
	{
		[Embed(source="../assets/hex_grid_green_by_metatality-d62eip6.png")]
		private var backgroundClass:Class;
		private var background:Bitmap = new backgroundClass();
		
		private var _storm:ParticlesStorm;
		private var _stormRect:Rectangle = new Rectangle(0, 0, 800, 600);
		private var _stormStartPoint:Point = new Point(400, 300);
		
		private var _follower:Sprite = new Sprite();
		
		private var _displacement_map:DisplacementMapFilter;
		private var _bmp:BitmapData;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			background.scaleY = background.scaleX = .5
			background.alpha = .5;
			addChild(background);
			
			addChild(new Stats());
			addChild(_follower);
			// entry point
			addEventListener(MouseEvent.CLICK, doStuff);
			addEventListener(MouseEvent.MOUSE_MOVE, follow);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_storm = new ParticlesStorm(_stormRect, _stormStartPoint, null, 50, 10, 0, 1, 10, 10, true, false);
			addChild(_storm);
		}
		
		private function follow(e:MouseEvent):void
		{
			_follower.x = stage.mouseX;
			_follower.y = stage.mouseY;
		}
		
		private function doStuff(e:MouseEvent):void
		{
			_storm.reset();
			_storm.setDynamicGenerator(_follower);
			_storm.generate();
		}
		
		private function onEnterFrame(e:Event):void
		{
			 _bmp = new BitmapData(800, 600);
			_displacement_map = new DisplacementMapFilter(_bmp, new Point(0, 0), 1, 2, 100, 100, DisplacementMapFilterMode.COLOR);
			_bmp.draw(_storm);
			background.filters = [_displacement_map];
		}
		
	}
	
}