/**
 * Space bug enemy entity
 */

module game.entity.SpaceBug;

import game.entity.model.AnimatedEntity;
import game.entity.model.Direction;

/**
 * Space bug entity class
 */

public class SpaceBug : AnimatedEntity
{
    /**
     * The path to the sprite image
     */

    public static enum IMG_PATH = "res/spacebug.png";

    /**
     * Constructor
     */

    public this ( )
    {
        super(2, 250, IMG_PATH, 0, 0, 32, 32);

        this.speed = 2.0;
    }
}
