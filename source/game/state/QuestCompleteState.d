/**
 * Quest complete state
 */

module game.state.QuestCompleteState;

import game.entity.TextEntity;
import game.state.model.IState;
import game.state.States;

import util.SDL;

/**
 * Quest complete state class
 */

public class QuestCompleteState : IState
{
    /**
     * The key of this state
     */

    public static enum KEY = "STATE_QUEST_COMPLETE";

    /**
     * Win message
     */

    private TextEntity win_message;

    /**
     * Initialize the state
     */

    override public void init ( )
    {
        this.win_message = new TextEntity("Quest complete!", SDL.Color.GREEN, 300, 200);
    }

    /**
     * Reset the state
     */

    override public void reset ( )
    {

    }

    /**
     * Render the state
     */

    override public void render ( )
    {
        this.win_message.draw();
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
        return true;
    }

    /**
     * Update the state
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last step
     *      states = State manager reference
     */

    override public void step ( uint ms, States states )
    {

    }
}
