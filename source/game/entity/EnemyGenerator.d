/**
 * Enemy generator, generates a given type of enemy
 */

module game.entity.EnemyGenerator;

import game.entity.model.Direction;
import game.entity.model.Entity;
import game.entity.model.Generator;

import std.random;

/**
 * Enemy generator class
 *
 * Template params:
 *      T = The type of enemy to generate, must be an Entity
 */

public class EnemyGenerator ( T : Entity ) : Generator!T
{
    /**
     * The rate at which to generate enemies per second
     */

    protected float frequency;

    /**
     * The direction to send the enemies in
     */

    protected Directions dir;

    /**
     * Number of elapsed milliseconds since the last update
     */

    protected uint elapsed;

    /**
     * Constructor
     *
     * Params:
     *      width = The game world width
     *      height = The game world height
     *      frequency = The generation frequency
     *      dir = The direction to move the enemies in
     */

    public this ( int width, int height, float frequency, Directions dir )
    {
        super(width, height);

        this.frequency = frequency;
        this.dir = dir;
    }

    /**
     * Randomly generate new enemies, and move the active ones
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last update
     *      spawn = Whether or not to check if a new enemy should be spawned
     */

    override public void update ( uint ms, bool spawn = true )
    {
        this.elapsed += ms;

        if ( spawn && this.elapsed >= 1000 / this.frequency )
        {
            auto enemy = this.generate();
            auto start_x = uniform(0, this.width - enemy.width);
            enemy.setPos(start_x, 0);
            enemy.dir = DIR_DOWN;

            this.elapsed = 0;
        }

        size_t[] to_remove;

        // Use foreach reverse so indexes can be saved largest first
        // For save recycling
        foreach_reverse ( i, enemy; this.active )
        {
            enemy.move(ms);

            if ( enemy.outOfBounds(this.width, this.height) )
            {
                to_remove ~= i;
            }
        }

        foreach ( i; to_remove )
        {
            this.recycle(i);
        }
    }

    /**
     * Draw the currently active enemies
     */

    override public void draw ( )
    {
        foreach ( enemy; this.active )
        {
            enemy.draw();
        }
    }
}
