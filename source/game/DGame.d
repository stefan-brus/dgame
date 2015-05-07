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
     * Game speed constant
     */

    private static const SPEED = 0.1;

    /**
     * Square Y-distance
     */

    private float sq_dist = 0;

    /**
     * Triangle X-distance
     */

    private float tri_dist = 0;

    /**
     * Render the world
     */

    public void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);

        this.drawSquare();
        this.drawTriangle();

        GL.flush();

        this.sq_dist -= this.sq_dist <= -100 ? 0 : SPEED;
        this.tri_dist += this.tri_dist >= 640 - 200 - 200 ? 0 : SPEED;
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

    /**
     * Draw the square
     */

    private void drawSquare ( )
    {
        GL.pushMatrix();
        GL.translate2f(0, this.sq_dist);
        GL.begin(GL.QUADS);
        GL.color3ub(0xFF, 0x00, 0x00);
        GL.vertex2f(200, 100);
        GL.vertex2f(400, 100);
        GL.vertex2f(400, 300);
        GL.vertex2f(200, 300);
        GL.end();
        GL.popMatrix();
    }

    /**
     * Draw the triangle
     */

    private void drawTriangle ( )
    {
        GL.pushMatrix();
        GL.translate2f(this.tri_dist, 0);
        GL.begin(GL.TRIANGLES);
        GL.color3ub(0xFF, 0x00, 0x00);
        GL.vertex2f(300, 100);
        GL.color3ub(0x00, 0xFF, 0x00);
        GL.vertex2f(400, 200);
        GL.color3ub(0x00, 0x00, 0xFF);
        GL.vertex2f(200, 200);
        GL.end();
        GL.popMatrix();
    }
}
