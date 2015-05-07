/**
 * Game interface
 *
 * Provides three methods:
 * - render: Render the world
 * - handle: Handle an event
 * - step: Update the world
 */

module game.model.IGame;

import util.SDL;

/**
 * IGame interface
 */

public interface IGame
{
    /**
     * Render the world
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
     * Update the world
     */

     void step ( );
}
