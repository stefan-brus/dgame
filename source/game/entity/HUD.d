/**
 * Heads-up display
 */

module game.entity.HUD;

import game.entity.TextEntity;
import game.world.World;

import util.SDL;

import std.conv;

/**
 * HUD class
 */

public class HUD
{
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
     * Constructor
     *
     * Params:
     *      width = The game width
     *      height = The game height
     */

    public this ( int width, int height )
    {
        // Create health indicator in bottom left corner
        this.health = new TextEntity("Health: " ~ to!string(World().player.health), SDL.Color.RED, 20, height - 60, 100, 60);

        // Create score indicator in bottom right corner
        this.score = new TextEntity("Score: " ~ to!string(World().player.score), SDL.Color.YELLOW, width - 120, height - 60, 120, 60);

        // Create mission objectives halfway down on the right hand side
        this.objectives_header = new TextEntity("Objectives:", SDL.Color.CYAN, width - 200, height / 2, 100, 40);
        this.objectives ~= new TextEntity("- Kill 50 space bugs", SDL.Color.CYAN, width - 200, height / 2 + 40, 200, 40);
    }

    /**
     * Draw the HUD
     */

    public void draw ( )
    {
        this.health.draw();
        this.score.draw();

        this.objectives_header.draw();
        foreach ( objective; this.objectives )
        {
            objective.draw();
        }
    }

    /**
     * Update the HUD
     */

    public void update ( )
    {
        this.health.setText("Health: " ~ to!string(World().player.health));
        this.score.setText("Score: " ~ to!string(World().player.score));
    }
}
