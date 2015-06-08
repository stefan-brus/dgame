/**
 * Quest handler
 */

module game.world.quest.Quests;

import game.world.World;

import std.conv;

/**
 * Quest handler class
 */

public class Quests
{
    /**
     * Quest interface
     */

    private interface IQuest
    {
        /**
         * Check if the quest is completed
         *
         * Returns:
         *      True if the quest is completed
         */

        bool isComplete ( );

        /**
         * Get the array of objectives strings for this quest
         *
         * Returns:
         *      The objectives in human-readable string format
         */

        string[] toObjectives ( );

        /**
         * Reset the quest objectives
         */

        void reset ( );
    }

    /**
     * The intro quest to kill 50 space bugs
     */

    private class IntroQuest : IQuest
    {
        /**
         * The number of killed space bugs
         */

        static enum BUGS_TO_KILL = 50;

        uint killed_bugs;

        override bool isComplete ( )
        {
            return this.killed_bugs >= BUGS_TO_KILL;
        }

        override string[] toObjectives ( )
        {
            return [to!string(this.killed_bugs) ~ "/" ~ to!string(BUGS_TO_KILL) ~ " space bugs killed"];
        }

        override void reset ( )
        {
            this.killed_bugs = 0;
        }
    }

    private IntroQuest intro_quest;

    /**
     * Reference to the current quest
     */

    public IQuest current;

    /**
     * Constructor
     */

    public this ( )
    {
        this.intro_quest = new IntroQuest();

        this.current = this.intro_quest;
    }

    /**
     * Handle the death of a given enemy type
     *
     * Params:
     *      enemy = The type of enemy that was killed
     */

    public void enemyKilled ( Enemies enemy )
    {
        if ( enemy == Enemies.SpaceBug )
        {
            this.intro_quest.killed_bugs++;
        }
    }
}
