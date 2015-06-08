/**
 * Main game state
 */

module game.state.GameState;

import game.entity.model.Direction;
import game.entity.model.Entity;
import game.entity.Asteroid;
import game.entity.EnemyGenerator;
import game.entity.HUD;
import game.entity.IrregularEnemyGenerator;
import game.entity.Player;
import game.entity.SpaceBug;
import game.state.model.IState;
import game.state.EndState;
import game.state.QuestCompleteState;
import game.state.States;
import game.world.World;

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
     * Heads-up display
     */

    private HUD hud;

    /**
     * Space bug generator
     */

    private alias BugGenerator = EnemyGenerator!SpaceBug;

    private BugGenerator bugs;

    /**
     * Asteroid generator
     */

    private alias AsteroidGenerator = IrregularEnemyGenerator!Asteroid;

    private AsteroidGenerator asteroids;

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
        this.bugs = new BugGenerator(this.width, this.height, 1, DIR_DOWN);
        this.asteroids = new AsteroidGenerator(10, this.width, this.height, 2, DIR_DOWN);
        this.hud = new HUD(this.width, this.height);
    }

    /**
     * Reset the state
     */

    override public void reset ( )
    {
        this.player.setPos(200, 200);
        this.player.shots.recycleAll();
        this.player.invul_time = 0;
        this.bugs.recycleAll();
        this.asteroids.recycleAll();

        World().player.health = 2;
        World().player.score = 0;

        World().quests.current.reset();
    }

    /**
     * Render the game
     */

    override public void render ( )
    {
        this.bugs.draw();
        this.asteroids.draw();
        this.player.draw();
        this.hud.draw();
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
            this.player.dir[Up] = key_state[SDL.Event.SCAN_W] > 0;
            this.player.dir[Left] = key_state[SDL.Event.SCAN_A] > 0;
            this.player.dir[Down] = key_state[SDL.Event.SCAN_S] > 0;
            this.player.dir[Right] = key_state[SDL.Event.SCAN_D] > 0;
        }

        this.player.is_shooting = key_state[SDL.Event.SCAN_SPACE] > 0;
        this.hud.show_objectives = key_state[SDL.Event.SCAN_TAB] > 0;

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
        this.player.update(ms);
        this.player.shoot(ms);

        this.bugs.update(ms);
        Entity.checkCollisions(this.player.shots.active, this.bugs.active);
        Entity.checkCollisions([this.player], this.bugs.active);

        this.asteroids.update(ms);
        Entity.checkCollisions(this.player.shots.active, this.asteroids.active);
        Entity.checkCollisions(this.bugs.active, this.asteroids.active);
        Entity.checkCollisions([this.player], this.asteroids.active);

        this.hud.update();

        if ( World().player.health == 0 )
        {
            states.setState(EndState.KEY);
        }
        else if ( World().quests.current.isComplete() )
        {
            states.setState(QuestCompleteState.KEY);
        }
    }
}
