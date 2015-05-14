/**
 * Shot generator, fires new shots and handles existing ones
 */

module game.entity.ShotGenerator;

import game.entity.model.Direction;
import game.entity.model.Entity;
import game.entity.model.Generator;

/**
 * Shot generator class
 *
 * Template params:
 *      T = The type of entity to fire, must be an Entity
 */

public class ShotGenerator ( T : Entity ) : Generator!T
{
    /**
     * The rate at which to fire shots, in shots per second
     */

    private uint rof;

    /**
     * The direction to fire in
     */

    private Directions dir;

    /**
     * Number of elapsed milliseconds since the last shoot check
     */

    private uint elapsed;

    /**
     * Constructor
     *
     * Params:
     *      width = The game world width
     *      height = The game world height
     *      rof = The rate of fire
     *      dir = The direction to fire in
     */

    public this ( int width, int height, uint rof, Directions dir )
    {
        super(width, height);

        this.rof = rof;
        this.dir = dir;
    }

    /**
     * Move the active shots
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last update
     */

    override public void update ( uint ms )
    {
        this.elapsed += ms;

        size_t[] to_remove;

        // Use foreach reverse so indexes can be saved largest first
        // For save recycling
        foreach_reverse ( i, shot; this.active )
        {
            shot.move(ms);

            if ( shot.outOfBounds(this.width, this.height) )
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
     * Draw the currently active shots
     */

    override public void draw ( )
    {
        foreach ( shot; this.active )
        {
            shot.draw();
        }
    }

    /**
     * Fire a new shot
     *
     * Params:
     *      x = The starting x position
     *      y = The starting y position
     */

    public void shoot ( float x, float y )
    {
        if ( this.elapsed >= 1000 / this.rof )
        {
            auto shot = this.generate();
            shot.setPos(x, y);
            shot.dir = this.dir;
            this.elapsed = 0;
        }
    }
}
