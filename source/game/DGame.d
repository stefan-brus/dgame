/**
 * Main game module
 *
 * Implements the game interface methods
 */

module game.DGame;

import game.entity.model.Direction;
import game.entity.model.Entity;
import game.model.IGame;

import util.GL;
import util.SDL;

/**
 * DGame class
 */

public class DGame : IGame
{
    /**
     * The size of the game area in pixels
     */

    private int width;
    private int height;

    /**
     * The player triangle entity
     */

    private class Triangle : Entity
    {
        public this ( )
        {
            super(200, 100, 200, 100);
            this.speed = 2.0;
        }

        override public void draw ( )
        {
            GL.begin(GL.TRIANGLES);
            GL.color3ub(0xFF, 0x00, 0x00);
            GL.vertex2f(this.x + (this.width / 2), this.y);
            GL.color3ub(0x00, 0xFF, 0x00);
            GL.vertex2f(this.x + this.width, this.y + this.height);
            GL.color3ub(0x00, 0x00, 0xFF);
            GL.vertex2f(this.x, this.y + this.height);
            GL.end();
        }
    }

    private Triangle player;

    /**
     * The square entity
     */

    private class Square : Entity
    {
        public this ( )
        {
            super(200, 100, 200, 200);
            this.speed = 0.75;
        }

        override public void draw ( )
        {
            GL.begin(GL.QUADS);
            GL.color3ub(0xFF, 0x00, 0x00);
            GL.vertex2f(this.x, this.y);
            GL.vertex2f(this.x + this.width, this.y);
            GL.vertex2f(this.x + this.width, this.y + this.height);
            GL.vertex2f(this.x, this.y + this.height);
            GL.end();
        }
    }

    private Square square;

    /**
     * The player's current direction
     */

    private Directions player_dir;

    /**
     * The square's current direction
     */

    private Directions square_dir;

    /**
     * Constructor
     *
     * Params:
     *      width = The game width
     *      height = The game height
     */

    public this ( int width, int height )
    {
        this.width = width;
        this.height = height;

        this.player = new Triangle();
        this.square = new Square();

        this.square_dir = DIR_UP;
    }

    /**
     * Render the world
     */

    public void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);

        this.square.draw();
        this.player.draw();

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
        // Move in the player's directions, minus any boundaries that may be touching
        auto bound_dirs = this.player.getBoundaries(this.width, this.height);
        auto dirs = .intersectDirs(this.player_dir, bound_dirs);

        this.player.move(dirs);

        // Move the square likewise
        bound_dirs = this.square.getBoundaries(this.width, this.height);
        dirs = intersectDirs(this.square_dir, bound_dirs);

        // Bounce the square if it hits a boundary
        if ( still(dirs) )
        {
            this.square_dir = this.square_dir == DIR_UP ? DIR_DOWN : DIR_UP;
            this.square.move(this.square_dir);
        }
        else
        {
            this.square.move(dirs);
        }
    }
}
