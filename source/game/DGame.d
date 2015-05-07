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
     * State to handle whether or not the player is moving in a certain direction
     */

    private alias bool[Direction] Directions;

    private enum Direction {
        UP,
        LEFT,
        DOWN,
        RIGHT
    }

    private Directions player_dir;

    /**
     * Game speed constant
     */

    private static enum SPEED = 2;

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
     *
     * Returns:
     *      True on success
     */

    public bool handle ( SDL.Event event )
    {
        auto key_state = SDL.getKeyboardState();

        if ( key_state is null )
        {
            return false;
        }

        with ( Direction )
        {
            this.player_dir[UP] = key_state[SDL.Event.SCAN_W] > 0;
            this.player_dir[LEFT] = key_state[SDL.Event.SCAN_A] > 0;
            this.player_dir[DOWN] = key_state[SDL.Event.SCAN_S] > 0;
            this.player_dir[RIGHT] = key_state[SDL.Event.SCAN_D] > 0;
        }

        return true;
    }

    /**
     * Update the world
     */

    public void step ( )
    {
        this.sq_dist -= this.sq_dist <= -100 ? 0 : SPEED;

        with ( Direction )
        {
            this.tri_y -= this.player_dir[UP] && this.tri_y + 100 >= 0 ? SPEED : 0;
            this.tri_x -= this.player_dir[LEFT] && this.tri_x + 200 >= 0 ? SPEED : 0;
            this.tri_y += this.player_dir[DOWN] && this.tri_y + 200 <= 480 ? SPEED : 0;
            this.tri_x += this.player_dir[RIGHT] && this.tri_x + 400 <= 640 ? SPEED : 0;
        }
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
