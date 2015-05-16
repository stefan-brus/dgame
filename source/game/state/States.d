/**
 * State manager thing
 */

module game.state.States;

import game.state.model.IState;

/**
 * States class
 */

public class States
{
    /**
     * The map of states
     */

    private IState[string] states;

    /**
     * The current state
     */

    private string cur_state;

    /**
     * Constructor
     *
     * Params:
     *      states = The states to manage
     */

    public this ( IState[string] states )
    in
    {
        assert(states.length > 0 );
    }
    body
    {
        this.states = states;
    }

    /**
     * Initialize the states
     */

    public void init ( )
    {
        foreach ( _, state; this.states )
        {
            state.init();
        }
    }

    /**
     * Set the current state to use
     *
     * Params:
     *      state = The key of the state
     */

    public void setState ( string state )
    {
        this.cur_state = state;
    }

    /**
     * Get the current state
     *
     * Returns:
     *      The current state
     */

    public IState current ( )
    in
    {
        assert(cur_state.length > 0 && cur_state in this.states);
    }
    body
    {
        return this.states[this.cur_state];
    }

    public alias opCall = current;
}
