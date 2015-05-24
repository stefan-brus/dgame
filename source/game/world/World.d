/**
 * The model of the game world
 */

module game.world.World;

/**
 * World singleton
 */

public class World
{
    /**
     * Singleton instance
     */

    private static World instance;

    /**
     * Player statistics
     */

    private struct Player
    {
        uint health;
        uint score;
    }

    public Player player;

    /**
     * Constructor, private because singleton
     */

    private this ( )
    {
        this.player.health = 2;
        this.player.score = 0;
    }

    /**
     * Static opCall, get the singleton instance
     *
     * Returns:
     *      The world instance
     */

    public static World opCall ( )
    {
        if ( instance is null )
        {
            instance = new World();
        }

        return instance;
    }
}
