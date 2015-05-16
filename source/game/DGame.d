/**
 * Main game module
 *
 * Implements the game interface methods
 */

module game.DGame;

import game.entity.model.SpriteEntity;
import game.model.IGame;
import game.state.model.IState;
import game.state.GameState;
import game.state.IntroState;
import game.state.States;

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
        "res/logo.png",
        "res/player.png",
        "res/spacebug.png"
    ];

    /**
     * The size of the game area in pixels
     */

    private int width;
    private int height;

    /**
     * The state manager
     */

    private States states;

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

        IState[string] init_states;
        init_states[IntroState.KEY] = new IntroState();
        init_states[GameState.KEY] = new GameState(this.width, this.height);

        this.states = new States(init_states);
    }

    /**
     * Initialize the game
     */

    override public void init ( )
    {
        SpriteEntity.initSprites(SPRITE_PATHS);

        this.states.init();
        this.states.setState(IntroState.KEY);
    }

    /**
     * Render the world
     */

    override public void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);

        this.states().render();

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
        return this.states().handle(event);
    }

    /**
     * Update the world
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last step
     */

    override public void step ( uint ms )
    {
        this.states().step(ms, this.states);
    }
}
