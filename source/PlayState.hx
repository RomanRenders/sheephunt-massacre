package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;

// TODO: IF SHOOTER GETS TOUCHED BY ENEMY, DIE. DONE
class PlayState extends FlxState
{
	public var enemiesToSpawn:Int = 0;

	public var bullets:FlxTypedGroup<FlxSprite>;

	var _sheep:Shooter; // WE ARE SIMPLY INITIALIZING OUR VAR. THE ARGS PASSED BELOW v
	var _vsBullets:FlxGroup;
	var _orcs:FlxTypedGroup<Orc>;
	var _house:House;

	var won:Bool;

	override public function create()
	{
		FlxG.mouse.visible = false;

		_house = new House(0, 0);
		add(_house);

		var numBullets:Int = 8;
		bullets = new FlxTypedGroup(numBullets);
		var sprite:FlxSprite;

		for (i in 0...numBullets)
		{
			sprite = new FlxSprite(-100, -100);

			// HERE IS WHERE THE BULLET IS FORMED
			sprite.makeGraphic(2, 2, FlxColor.WHITE);
			sprite.exists = false;

			bullets.add(sprite);
		}
		add(bullets);

		// ORC SPAWN STUFF:
		var heights:Array<Int> = [200, 240];
		var spawns:Array<Int> = [10, 15, 35, 50];

		var numOrcs:Int = 20;
		_orcs = new FlxTypedGroup(numOrcs);
		var o:Orc;

		for (i in 0...numOrcs)
		{
			// ORIGINAL:
			// a = new Alien(8 + (i % 10) * 32, 24 + Std.int(i / 10) * 32, colors[Std.int(i / 10)], alienBullets);

			// X, Y
			// "+ Std.int(i / 10) * 32" is what breaks it into two rows
			o = new Orc(240 + (i * FlxG.random.int(10, 20)), 100 + Std.int(i / 10) * 32);

			_orcs.add(o);
		}
		add(_orcs);

		_sheep = new Shooter(30, 135); // 130 HEIGHT
		add(_sheep);

		_vsBullets = new FlxGroup();
		_vsBullets.add(_orcs); // kill orcs when touched by bullets

		super.create();
	}

	function stuffHitStuff(Object1:FlxObject, Object2:FlxObject):Void
	{
		Object1.kill();
		Object2.kill();
	}

	function doneFadeOut()
	{
		FlxG.switchState(new GameOver(false));
	}

	function orcTouchSheep(_sheep:Shooter, enemy:Orc)
	{
		// if (player.alive && player.exists && enemy.alive && enemy.exists && !enemy.isFlickering())
		// {
		// 	startCombat(enemy);
		// }
		_sheep.kill();
		doneFadeOut();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.overlap(bullets, _vsBullets, stuffHitStuff);
		FlxG.overlap(_sheep, _orcs, orcTouchSheep);

		// if (_orcs.x < 0)
		// {
		// 	doneFadeOut();
		// }
	}
}
