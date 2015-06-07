/**
 * The model of the game world
 */

module game.world.World;

import game.world.quest.Quests;

/**
 * Convenience alias
 */

public alias Enemies = World.Enemies;

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
     * Types of enemies
     */

    public enum Enemies
    {
        SpaceBug
    }

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
     * Quest handler
     */

    public Quests quests;

    /**
     * Constructor, private because singleton
     */

    private this ( )
    {
        this.player.health = 2;
        this.player.score = 0;

        this.quests = new Quests();
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
