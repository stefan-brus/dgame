/**
 * Interface for managing a game state
 *
 * Very similar to IGame right now, hmm
 */

module game.state.model.IState;

import util.SDL;

/**
 * IState interface
 */

public interface IState
{
    /**
     * Initialize the state
     */

    void init ( );

    /**
     * Render the state
     */

    void render ( );

    /**
     * Handle the given event
     *
     * Params:
     *      event = The event
     *
     * Returns:
     *      True if successful
     */

    bool handle ( SDL.Event event );

    /**
     * Update the state
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last step
     */

     void step ( uint ms );
}
