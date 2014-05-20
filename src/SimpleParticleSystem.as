package  
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Alex Popescu
	 */
	public class SimpleParticleSystem extends Sprite
	{
		private var _particleSystem:Object;
		private var _particlesPool:Vector.<SimpleParticle> = new Vector.<SimpleParticle>;
		private var _particles:Vector.<SimpleParticle> = new Vector.<SimpleParticle>;
		private var _bounds:Rectangle;
		private var _decayTime:uint = 100;
		private var _startPoint:Point;
		private var _speed:uint = 10;
		private var _particlesCounter:uint = 0;
		private var _gravityPoint:Point;
		private var _wind:uint = 0;
		private var _added:Boolean = false;
		private var _behaviour:uint = 0;
		private var _gravity:uint = 100;
		private var _autoDecay:Boolean = false;
		private var _customGenerator:Sprite;
		private var _waveSize:uint = 1;
		private var _waveCounter:uint = 0;
		private var _rotateOnPoint:Boolean = false;
		
		/**
		 * 
		 * @param	nrOfParticles
		 * @param	bounds
		 * @param	startPoint
		 * @param	gravityPoint
		 * @param	speed
		 * @param	wind
		 * @param	behaviour
		 * @param	decayTime
		 * @param	gravity
		 * @param	autoDecay
		 * @param	rotateOnPoint
		 * @param	message
		 */
		public function SimpleParticleSystem(nrOfParticles:uint = 100, 
											bounds:Rectangle = null, 
											startPoint:Point = null, 
											gravityPoint:Point = null,
											speed:uint = 0,
											wind:uint = 0,
											behaviour:uint = 0,
											decayTime:uint = 1000,
											gravity:uint = 1,
											autoDecay:Boolean = false,
											rotateOnPoint:Boolean = false) 
		{
			_rotateOnPoint = rotateOnPoint;
			_gravity = gravity;
			_autoDecay = autoDecay;
			
			if (speed != 0)
			{
				_speed = speed;
			}
			
			if (wind != 0)
			{
				_wind = wind;
			}
			
			if (behaviour != 0)
			{
				_behaviour = behaviour;
			}
			
			if (decayTime != 0)
			{
				_decayTime = decayTime;
			}
			
			if (gravityPoint != null)
			{
				_gravityPoint = gravityPoint;
			}
			if (bounds != null)
			{
				_bounds = bounds;
			}
			else
			{
				_bounds = new Rectangle(0, 0, 800, 600);
			}
			
			if (startPoint != null)
			{
				_startPoint = startPoint;
			}
			else
			{
				_startPoint = new Point(700, 450);
			}
			
			for (var i:uint = 0; i < nrOfParticles; i++ )
			{
				_particlesPool.push(new SimpleParticle());
			}
		}
		
		/**
		 * 
		 */
		public function get particleSystem():Object
		{
			_particleSystem = {
								allParticles:_particles
								}
			return _particleSystem;
		}
		
		/**
		 * 
		 * @param	e
		 */
		public function step(e:Event):void
		{
			addWave();
			for (var i:uint = 0; i < _particles.length; i++ )
			{
				if (_particles[i].parent != null)
				{
					_particles[i].visible = true;
					(_particles[i] as SimpleParticle).decay = _autoDecay;
					animate(_particles[i] as SimpleParticle);
				}
			}
		}
		
		/**
		 * 
		 */
		private function addWave():void
		{
			for (var i:uint = _waveCounter; i < _waveCounter+Math.random()*_waveSize; i++ )
			{
				if (_particlesPool.length > 0)
				{
					var p:SimpleParticle = _particlesPool.shift();
					p._index = _particles.length;
					p.speed = _speed;
					p.decayTime = _decayTime;
					addChild(p);
					if (_customGenerator != null)
						{
							p.x = _bounds.x + _customGenerator.x ;
							p.y = _bounds.y + _customGenerator.y;
							p.rotation = Math.random()*360;
						}
						else
						{
							p.x = _bounds.x + _startPoint.x;
							p.y = _bounds.y + _startPoint.y;
							p.rotation = Math.random()*360;
						}
						_particles.push(p);
				}
			}
			_waveCounter += _waveSize;
		}
		
		private function animate(t:SimpleParticle):void
		{
			
			var dirX:int = 1;
			var dirY:int = 1;
			
			if (t.revXmin || t.revXmax)
			{
				dirX *= -1;
			}
			
			if (t.revYmin || t.revYmax)
			{
				dirY *= -1;
			}
			
			if (t.decay)
			{
				t.alpha -= .005 + (Math.random() * 10) / 10000;
			}
			
			if (t.alpha <= 0)
			{
				recycleParticle(t);
			}
			
										 
			t.x += t.speed * Math.cos(t.rotation * Math.PI / 180) * dirX / 2;
			t.y += t.speed * Math.sin(t.rotation * Math.PI / 180) * dirY / 2;
			if (_rotateOnPoint)
			{
				t.rotation += Math.random()*15; //this is also fun
			}
		
			if (t.x < 0)
			{
				t.revXmin = true;
				t.revXmax = false;
				t.decay = true;
			}
			
			if (t.y < 0)
			{
				t.revYmin = true;
				t.revYmax = false;
				t.decay = true;
			}
			//
			if (t.x > _bounds.width)
			{
				t.revXmax = true;
				t.revXmin = false;
				t.decay = true;
			}
			
			if (t.y > _bounds.height)
			{
				t.revYmax = true;
				t.revYmin = false;
				t.decay = true;
			}
			
		}
		
		public function reset():void
		{
			if (_particlesPool.length == 0)
			{
				_added = false;
				removeEventListener(Event.ENTER_FRAME, step);
				_particlesCounter = 0;
				_waveCounter = 0;
				for (var i:uint = 0; i < _particles.length; i++ )
				{
					removeChild(_particles[i]);
					(_particles[i] as SimpleParticle).x = 0;
					(_particles[i] as SimpleParticle).y = 0;
					(_particles[i] as SimpleParticle).rotation = 0;
					(_particles[i] as SimpleParticle).revYmax = false;
					(_particles[i] as SimpleParticle).decay = false;
					(_particles[i] as SimpleParticle).revYmin = false;
					(_particles[i] as SimpleParticle).revXmax = false;
					(_particles[i] as SimpleParticle).revXmin = false;
					_particles[i].alpha = 1;
					_particlesPool.push(_particles[i]);
				}
				_particles = new Vector.<SimpleParticle>;
			}
		}
		
		private function recycleParticle(target:SimpleParticle):void
		{	
				target.alpha = 1;
				removeChild(target);
				_particlesPool.push(target);
				_particles.splice(_particles.indexOf(target), 1)
		}
		
		public function set customGenearator(generator:Sprite):void
		{
			_customGenerator = generator;
		}
		
	}

}