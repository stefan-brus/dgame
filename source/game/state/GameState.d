/**
 * Main game state
 */

module game.state.GameState;

import game.entity.model.Direction;
import game.entity.model.Entity;
import game.entity.EnemyGenerator;
import game.entity.Player;
import game.entity.SpaceBug;
import game.entity.StarGenerator;
import game.state.model.IState;
import game.state.States;

import util.SDL;

/**
 * GameState class
 */

public class GameState : IState
{
    /**
     * The key of this state
     */

    public static enum KEY = "STATE_GAME";

    /**
     * The size of the game area in pixels
     */

    private int width;
    private int height;

    /**
     * The player entity
     */

    private Player player;

    /**
     * The background star generator
     */

    private StarGenerator stars;

    /**
     * Space bug generator
     */

    private alias EnemyGenerator!SpaceBug BugGenerator;

    private BugGenerator bugs;

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
    }

    /**
     * Initialize the state
     */

    override public void init ( )
    {
        this.player = new Player(this.width, this.height);
        this.stars = new StarGenerator(this.width, this.height);
        this.bugs = new BugGenerator(this.width, this.height, 1, DIR_DOWN);
    }

    /**
     * Render the game
     */

    override public void render ( )
    {
        this.stars.draw();
        this.bugs.draw();
        this.player.draw();
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

        with ( Direction )
        {
            this.player.dir[UP] = key_state[SDL.Event.SCAN_W] > 0;
            this.player.dir[LEFT] = key_state[SDL.Event.SCAN_A] > 0;
            this.player.dir[DOWN] = key_state[SDL.Event.SCAN_S] > 0;
            this.player.dir[RIGHT] = key_state[SDL.Event.SCAN_D] > 0;
        }

        this.player.is_shooting = key_state[SDL.Event.SCAN_SPACE] > 0;

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
        // Move in the player's directions, minus any boundaries that may be touching
        auto bound_dirs = this.player.getBoundaries(this.width, this.height);
        this.player.dir = intersectDirs(this.player.dir, bound_dirs);

        this.player.move(ms);
        this.player.shoot(ms);

        this.stars.update(ms);
        this.bugs.update(ms);

        Entity.checkCollisions(this.player.shots.active, this.bugs.active);
    }
}
