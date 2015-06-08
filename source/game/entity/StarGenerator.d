/**
 * Star generator, randomly generates stars to create spacey effects
 */

module game.entity.StarGenerator;

import game.entity.model.Direction;
import game.entity.model.Generator;
import game.entity.Star;

import std.random;

/**
 * StarGenerator class
 */

public class StarGenerator : Generator!Star
{
    /**
     * The frequency of newly generated stars in %
     */

    private static enum FREQUENCY = 5;

    /**
     * The number of initial stars to generate
     */

    private static enum INIT_STARS = 100;

    /**
     * Constructor
     *
     * Params:
     *      width = The game world width
     *      height = The game world height
     */

    public this ( int width, int height )
    {
        super(width, height);

        this.generateInitStars();
    }

    /**
     * Randomly generate new stars, and move the active ones
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last update
     *      spawn = unused
     */

    override public void update ( uint ms, bool spawn = true )
    {
        if ( uniform(1, 100) <= FREQUENCY )
        {
            auto start_x = uniform(0, this.width);
            this.createAt(start_x, 0);
        }

        size_t[] to_remove;

        // Use foreach reverse so indexes can be saved largest first
        // For save recycling
        foreach_reverse ( i, star; this.active )
        {
            star.move(ms);

            if ( star.outOfBounds(this.width, this.height) )
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
     * Draw the currently active stars
     */

    override public void draw ( )
    {
        foreach ( star; this.active )
        {
            star.draw();
        }
    }

    /**
     * Generate the initial stars
     */

    private void generateInitStars ( )
    {
        int i = 0;

        while ( i < INIT_STARS )
        {
            auto x = uniform(0, this.width);
            auto y = uniform(0, this.height);

            this.createAt(x, y);

            i++;
        }
    }

    /**
     * Create a star at the given coordinates
     *
     * Params:
     *      x = The x position
     *      y = The y position
     */

    private void createAt ( float x, float y )
    {
        auto star = this.generate();
        star.setPos(x, y);
        star.generateColor();
        star.generateSpeed();
        star.dir = DIR_DOWN;
    }
}
