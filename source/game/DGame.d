/**
 * Main game module
 *
 * Implements the game interface methods
 */

module game.DGame;

import game.entity.model.SpriteEntity;
import game.model.IGame;
import game.state.GameState;

import util.GL;
import util.SDL;

/**
 * DGame class
 */

public class DGame : IGame
{
    /**
     * Paths to sprites used by the game
     */

    private static enum SPRITE_PATHS = [
        "res/player.png",
        "res/spacebug.png"
    ];

    /**
     * The size of the game area in pixels
     */

    private int width;
    private int height;

    /**
     * The game state
     */

    private GameState state;

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

        this.state = new GameState(this.width, this.height);
    }

    /**
     * Initialize the game
     */

    override public void init ( )
    {
        SpriteEntity.initSprites(SPRITE_PATHS);

        this.state.init();
    }

    /**
     * Render the world
     */

    override public void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);

        this.state.render();

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

    override public bool handle ( SDL.Event event )
    {
        return this.state.handle(event);
    }

    /**
     * Update the world
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last step
     */

    override public void step ( uint ms )
    {
        this.state.step(ms);
    }
}
