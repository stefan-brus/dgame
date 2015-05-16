/**
 * Intro state - displays the game logo
 */

module game.state.IntroState;

import game.entity.model.Entity;
import game.entity.model.SpriteEntity;
import game.state.model.IState;
import game.state.GameState;
import game.state.States;

import util.SDL;

/**
 * Intro state class
 */

public class IntroState : IState
{
    /**
     * The key of this state
     */

    public static enum KEY = "STATE_INTRO";

    /**
     * Logo sprite entity
     */

    private class Logo : SpriteEntity
    {
        this ( )
        {
            enum PATH = "res/logo.png";
            super(PATH, 150, 150, 512, 256);
        }

        override public void collide ( Entity ) { }
    }

    private Logo logo;

    /**
     * Whether or not the player has started the game
     */

    private bool game_started;

    /**
     * Initialize the state
     */

    override public void init ( )
    {
        this.logo = new Logo();
    }

    /**
     * Render the game
     */

    override public void render ( )
    {
        this.logo.draw();
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

        if ( key_state[SDL.Event.SCAN_RETURN] > 0 )
        {
            this.game_started = true;
        }

        return true;
    }

    /**
     * Update the world
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last step
     *      states = State manager reference
     */

    override public void step ( uint ms, States states )
    {
        if ( this.game_started )
        {
            states.setState(GameState.KEY);

            this.game_started = false;
        }
    }
}
