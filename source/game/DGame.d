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
        static const speed = 0.1;
        static float sq_dist = 0;
        static float tri_dist = 0;
        GL.clear(GL.COLOR_BUFFER_BIT);

        GL.pushMatrix();
        GL.translate2f(0, sq_dist);
        GL.begin(GL.QUADS);
        GL.color3ub(0xFF, 0x00, 0x00);
        GL.vertex2f(200, 100);
        GL.vertex2f(400, 100);
        GL.vertex2f(400, 300);
        GL.vertex2f(200, 300);
        GL.end();
        GL.popMatrix();

        GL.pushMatrix();
        GL.translate2f(tri_dist, 0);
        GL.begin(GL.TRIANGLES);
        GL.color3ub(0xFF, 0x00, 0x00);
        GL.vertex2f(300, 100);
        GL.color3ub(0x00, 0xFF, 0x00);
        GL.vertex2f(400, 200);
        GL.color3ub(0x00, 0x00, 0xFF);
        GL.vertex2f(200, 200);
        GL.end();
        GL.popMatrix();

        GL.flush();
        sq_dist -= sq_dist <= -100 ? 0 : speed;
        tri_dist += speed;
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
