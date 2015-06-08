/**
 * Enemy generator that generates at irregular, random intervals
 */

module game.entity.IrregularEnemyGenerator;

import game.entity.model.Direction;
import game.entity.model.Entity;
import game.entity.EnemyGenerator;

import std.random;

/**
 * IrregularEnemyGenerator class
 *
 * Template params:
 *      T = The type of enemy to generate, must be an Entity
 */

public class IrregularEnemyGenerator ( T : Entity ) : EnemyGenerator!T
{
    /**
     * The chance to spawn an enemy per "tick", in percent
     *
     * This is used rather than frequency to determine spawns
     */

    private uint rate;

    /**
     * Constructor
     *
     * Params:
     *      rate = The chance to spawn an enemy once
     *      width = The game world width
     *      height = The game world height
     *      frequency = The generation frequency
     *      dir = The direction to move the enemies in
     */

    public this ( uint rate, int width, int height, float frequency, Directions dir )
    {
        super(width, height, frequency, dir);

        this.rate = rate;
    }

    /**
     * Invariant, rate must always be in the percentage range, between 0 and 100
     */

    invariant
    {
        assert(rate > 0 && rate < 100);
    }

    /**
     * Randomly generate new enemies, and move the active ones
     *
     * Resets "elapsed" between ticks
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last update
     *      spawn = unused
     */

    override public void update ( uint ms, bool spawn = true )
    {
        super.update(ms, false);

        if ( this.elapsed >= 1000 / this.frequency )
        {
            auto should_spawn = 100 - uniform(1, 99) <= this.rate;

            if ( should_spawn )
            {
                auto enemy = this.generate();
                auto start_x = uniform(0, this.width - enemy.width);
                enemy.setPos(start_x, 0);
                enemy.dir = DIR_DOWN;
            }

            this.elapsed = 0;
        }
    }
}
