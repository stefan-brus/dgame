/**
 * Heads-up display
 */

module game.entity.HUD;

import game.entity.TextEntity;

import util.SDL;

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
     * Constructor
     *
     * Params:
     *      width = The game width
     *      height = The game height
     */

    public this ( int width, int height )
    {
        // Create health indicator in bottom left corner
        this.health = new TextEntity("Health: 99", SDL.Color.RED, 20, height - 60, 100, 60);

        // Create score indicator in bottom right corner
        this.score = new TextEntity("Score: 99999", SDL.Color.YELLOW, width - 120, height - 60, 120, 60);
    }

    /**
     * Draw the HUD
     */

    public void draw ( )
    {
        this.health.draw();
        this.score.draw();
    }
}
