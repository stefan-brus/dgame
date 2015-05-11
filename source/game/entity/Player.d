/**
 * The player entity
 */

module game.entity.Player;

import game.entity.model.SpriteEntity;

/**
 * Player entity class
 */

public class Player : SpriteEntity
{
    /**
     * The path to the sprite image
     */

    public static const IMG_PATH = "res/player.png";

    /**
     * Constructor
     */

    public this ( )
    {
        super(IMG_PATH, 200, 200, 64, 64);

        this.speed = 4.0;
    }
}
