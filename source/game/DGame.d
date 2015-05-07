/**
 * Main game module
 *
 * Implements the game interface methods
 */

module game.DGame;

import game.model.IGame;

import util.GL;
import util.SDL;

/**
 * DGame class
 */

public class DGame : IGame
{
    /**
     * Game speed constant
     */

    private static const SPEED = 10;

    /**
     * Square Y-distance
     */

    private float sq_dist = 0;

    /**
     * Triangle distance
     */

    private float tri_x = 0;
    private float tri_y = 0;

    /**
     * Render the world
     */

    public void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);

        this.drawSquare();
        this.drawTriangle();

        GL.flush();
    }

    /**
     * Handle the given event
     *
     * Params:
     *      event = The event
     */

    public void handle ( SDL.Event event )
    {
        if ( event().type == SDL.Event.KEYDOWN )
        {
            switch ( event().key.keysym.sym )
            {
                case SDL.Event.KEY_W:
                    tri_y -= tri_y + 100 <= 0 ? 0 : SPEED;
                    break;

                case SDL.Event.KEY_A:
                    tri_x -= tri_x + 200 <= 0 ? 0 : SPEED;
                    break;

                case SDL.Event.KEY_S:
                    tri_y += tri_y + 200 >= 480 ? 0 : SPEED;
                    break;

                case SDL.Event.KEY_D:
                    tri_x += tri_x + 400 >= 640 ? 0 : SPEED;
                    break;

                default:
                    return;
            }
        }
    }

    /**
     * Update the world
     *
     * Params:
     *      ms = The amount of time lapsed in milliseconds
     */

    public void step ( uint ms )
    {
        this.sq_dist -= this.sq_dist <= -100 ? 0 : SPEED;
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
        GL.translate2f(this.tri_x, this.tri_y);
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
