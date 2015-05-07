/**
 * Main game module
 *
 * Implements the game interface methods
 */

module game.DGame;

import game.model.IGame;

import util.GL;

/**
 * DGame class
 */

public class DGame : IGame
{
    /**
     * Render the world
     */

    public void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);
        GL.color3ub(0xFF, 0x00, 0x00);
        GL.begin(GL.QUADS);
        GL.vertex2f(200, 100);
        GL.vertex2f(400, 100);
        GL.vertex2f(400, 300);
        GL.vertex2f(200, 300);
        GL.end();
        GL.flush();
    }

    /**
     * Handle the given event
     */

    public void handle ( )
    {

    }

    /**
     * Update the world
     *
     * Params:
     *      ms = The amount of time lapsed in milliseconds
     */

    public void step ( uint ms )
    {

    }
}
