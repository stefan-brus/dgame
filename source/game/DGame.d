/**
 * Main game module
 *
 * Implements the game interface methods
 */

module game.DGame;

import game.entity.model.SpriteEntity;
import game.entity.StarGenerator;
import game.model.IGame;
import game.state.model.IState;
import game.state.EndState;
import game.state.GameState;
import game.state.IntroState;
import game.state.QuestCompleteState;
import game.state.States;
import game.SoundLib;

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
     * The background star generator
     */

    private StarGenerator stars;

    /**
     * Whether or not 'M' has been released
     *
     * TODO: Come up with a better solution for this hack
     */

    private bool m_released;

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
        init_states[EndState.KEY] = new EndState();
        init_states[QuestCompleteState.KEY] = new QuestCompleteState();

        this.states = new States(init_states);
        this.m_released = true;
    }

    /**
     * Initialize the game
     */

    override public void init ( )
    {
        SpriteEntity.initSprites(SPRITE_PATHS);

        this.states.init();
        this.states.setState(IntroState.KEY);

        this.stars = new StarGenerator(this.width, this.height);

        SoundLib().startMusic(SoundLib.MUSIC);
    }

    /**
     * Render the world
     */

    override public void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);

        this.stars.draw();
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
        auto key_state = SDL.getKeyboardState();

        if ( key_state is null )
        {
            return false;
        }

        if ( this.m_released &&
             key_state[SDL.Event.SCAN_LCTRL] &&
             event().type == SDL.Event.KEYDOWN &&
             event.getScancode() == SDL.Event.SCAN_M )
        {
            SoundLib().toggleMusic();
            this.m_released = false;
        }
        else if ( event().type == SDL.Event.KEYUP &&
                  event.getScancode() == SDL.Event.SCAN_M )
        {
            this.m_released = true;
        }

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
        this.stars.update(ms);

        this.states().step(ms, this.states);
    }
}
