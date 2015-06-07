/**
 * Heads-up display
 */

module game.entity.HUD;

import game.entity.TextEntity;
import game.world.World;

import util.GL;
import util.SDL;

import std.conv;

/**
 * HUD class
 */

public class HUD
{
    /**
     * How far from the right edge to display the objectives
     */

    private static enum OBJECTIVES_OFFSET = 250;

    /**
     * Dimensions of the game world
     */

    private int width;
    private int height;

    /**
     * Health indicator
     */

    private TextEntity health;

    /**
     * Score counter
     */

    private TextEntity score;

    /**
     * Mission objectives
     */

    private TextEntity objectives_header;
    private TextEntity[] objectives;

    /**
     * Whether or not to display the current objectives
     */

    public bool show_objectives;

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

        // Create health indicator in bottom left corner
        this.health = new TextEntity("Health: " ~ to!string(World().player.health), SDL.Color.RED, 20, height - 60);

        // Create score indicator in bottom right corner
        this.score = new TextEntity("Score: " ~ to!string(World().player.score), SDL.Color.YELLOW, width - 120, height - 60);

        // Create mission objectives halfway down on the right hand side
        this.objectives_header = new TextEntity("Objectives (tab):", SDL.Color.CYAN, width - OBJECTIVES_OFFSET, height / 2);
        this.createObjectives();
    }

    /**
     * Draw the HUD
     */

    public void draw ( )
    {
        this.health.draw();
        this.score.draw();

        if ( this.show_objectives )
        {
            this.objectives_header.draw();
            foreach ( objective; this.objectives )
            {
                objective.draw();
            }
        }
        else
        {
            GL.color4ub(0xFF, 0xFF, 0xFF, 0x44);
            this.objectives_header.draw();
        }
    }

    /**
     * Update the HUD
     */

    public void update ( )
    {
        this.health.setText("Health: " ~ to!string(World().player.health));
        this.score.setText("Score: " ~ to!string(World().player.score));

        this.updateObjectives();
    }

    /**
     * Update the quest objective texts
     */

    private void updateObjectives ( )
    {
        auto obj_strs = World().quests.current.toObjectives();
        assert(obj_strs.length == this.objectives.length);

        foreach ( i, str; obj_strs )
        {
            this.objectives[i].setText("- " ~ str);
        }
    }

    /**
     * Create the objectives text based on the current quest
     */

    private void createObjectives ( )
    {
        static enum OBJECTIVE_TEXT_HEIGHT = 40;

        this.objectives.length = 0;

        foreach ( i, obj; World().quests.current.toObjectives() )
        {
            this.objectives ~= new TextEntity("- " ~ obj, SDL.Color.CYAN, this.width - OBJECTIVES_OFFSET, this.height / 2 + OBJECTIVE_TEXT_HEIGHT * (i + 1));
        }
    }
}
