package  
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Alex Popescu
	 */
	public class ParticlesStorm extends Sprite
	{
		
		//default values
		private var _numberOfParticles:uint = 500;
		private var _system:SimpleParticleSystem;
		private var _rect:Rectangle;
		private var _startPoint:Point;
		private var _gravityPoint:Point;
		private var _bmpData:BitmapData;
		private var _animData:BitmapData;
		private var _bmp:Bitmap;
		private var _systemW:uint = 800;
		private var _systemH:uint = 600;
		private var _glowFilter:GlowFilter =  new GlowFilter(0x66CCFF ,.5, 10, 10, 5, BitmapFilterQuality.LOW);
		private var _gradientGlowFilter:GradientGlowFilter =  new GradientGlowFilter();
		private var _blurFilter:BlurFilter = new BlurFilter(2, 2);
		private var _decayStep:uint = 20;
		private var _decayIncrement:uint = 0;
		private var _gravity:uint = 100;
		private var _message:String = "";
		private var _tField:TextField;
		
		private var clamp:Boolean = true;
        private var clampColor:Number = 0xFF0000;
        private var clampAlpha:Number = 1;
        
        private var bias:Number = -1;
        private var preserveAlpha:Boolean = false;
        private var matrixCols:Number = 3;
        private var matrixRows:Number = 3;
        private var matrix:Array = [ 1,1,1,
													1,1,1,
													1,1,1 ];
        
        private var _convolutionFilter:ConvolutionFilter = new ConvolutionFilter(matrixCols, matrixRows, matrix, matrix.length, bias, preserveAlpha, clamp, clampColor, clampAlpha);
		
		public function ParticlesStorm(rect:Rectangle = null, 
									startPoint:Point = null, 
									gravityPoint:Point = null, 
									numberOfParticles:uint = 0,
									speed:uint = 0,
									wind:uint = 0,
									behaviour:uint = 0,
									decayTime:uint = 1000,
									gravity:uint = 1,
									autoDecay:Boolean = false,
									rotateOnPoint:Boolean = false,
									message:String = "") 
		{
			_message = message;
			
			if (rect != null)
			{
				_rect = rect;
				_systemW = rect.width;
				_systemH = rect.height;
			}
			else
			{
				_rect = new Rectangle(0, 0, _systemW, _systemH);
			}
			if (startPoint != null)
			{
				_startPoint = startPoint;
			}
			else 
			{
				_startPoint = new Point(700, 550);
			}
			if (gravityPoint != null)
			{
				_gravityPoint = gravityPoint;
			}
			else
			{
				_gravityPoint = new Point(-400, -300);
			}
			if (numberOfParticles != 0)
			{
				_numberOfParticles = numberOfParticles;
			}
			
			_gravity = gravity;
			
			_system = new SimpleParticleSystem(_numberOfParticles, 
												_rect, 
												_startPoint, 
												_gravityPoint,
												speed,
												wind,
												behaviour,
												decayTime,
												1,
												autoDecay,
												rotateOnPoint
												);
			
			_bmpData = new BitmapData(_systemW, _systemH, true, Math.random()*0xffffff);
			_animData = new BitmapData(_systemW, _systemH, true, Math.random()*0xffffff);
			
			_glowFilter.quality = BitmapFilterQuality.LOW;
			
			_bmp = new Bitmap(_bmpData);
			
			_gradientGlowFilter.distance = 0; 
			_gradientGlowFilter.angle = 45; 
			_gradientGlowFilter.colors = [0x00FF00, 0xFF0000]; 
			_gradientGlowFilter.alphas = [0, 1]; 
			_gradientGlowFilter.ratios = [0, 255]; 
			_gradientGlowFilter.blurX = 40; 
			_gradientGlowFilter.blurY = 40; 
			_gradientGlowFilter.strength = 2; 
			_gradientGlowFilter.quality = BitmapFilterQuality.HIGH; 
			_gradientGlowFilter.type = BitmapFilterType.OUTER; 
			
			_bmp.filters = [_gradientGlowFilter];
			//_bmp.filters = [_glowFilter];
			//_bmp.blendMode = BlendMode.SCREEN;
			addChild(_bmp);
		}
		
		public function generate():void
		{
			this.visible = true;
			addEventListener(Event.ENTER_FRAME, doStep);
			
		}
		
		private function doStep(e:Event):void
		{
			_system.step(e);
			_bmpData.lock();
			_bmpData.applyFilter(_bmpData, _bmpData.rect, new Point(), _convolutionFilter);
			//_bmpData.fillRect(_bmpData.rect, 0);
			_bmpData.draw(_system);
			_bmpData.unlock();
		}
		
		public function reset():void
		{
			//this.visible = false;
			//_blurFilter.blurX = 0;
			//_blurFilter.blurY = 0;
			//removeEventListener(Event.ENTER_FRAME, doStep);
			//_bmpData.fillRect(_bmpData.rect, 0);
			_bmpData.draw(_system);
			system.reset();
		}
		
		public function get system():SimpleParticleSystem
		{
			return _system;
		}
		
		public function setDynamicGenerator(generator:Sprite):void
		{
			_system.customGenearator = generator;
		}
		
	}

}