package  
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Alex Popescu
	 */
	public class SimpleParticle extends Sprite
	{
		public var _index:uint = 0;
		
		public var  revXmin:Boolean = false;
		public var  revYmin:Boolean = false;
		public var  revXmax:Boolean = false;
		public var revYmax:Boolean = false;
		
		public var decayTime:uint = 1000;
		public  var decay:Boolean = false;
		public var speed:uint = 15 - Math.random()*10;
		private var _transfMatrix:Matrix = new Matrix();
		private var _shape:Sprite = new Sprite();
		
		public function SimpleParticle() 
		{
			//_particle.scaleX = _particle.scaleY = .2;
			this.addChild(_shape);
			_shape.graphics.lineStyle(1, Math.random()*0xffffff);
			//_shape.graphics.beginFill(Math.random()*0xffffff, 1);
			//_shape.graphics.drawCircle(0, 0, 20);
			_shape.graphics.drawRect(0, 0,  Math.random()*30, 1);
			_shape.graphics.endFill();
		}
		
		/**
		 * 
		 * @param	amount
		 */
		public function rotateGraphics(amount:Number):void
		{
			_shape.rotation += amount;
		}
	}

}