/**
 * Asteroid entity
 */

module game.entity.Asteroid;

import game.entity.model.Entity;
import game.entity.model.SpriteEntity;
import game.world.World;

/**
 * Asteroid entity class
 */

public class Asteroid : SpriteEntity
{
    /**
     * The path to the sprite image
     */

    public static enum IMG_PATH = "res/asteroid.png";

    /**
     * Constructor
     */

    public this ( )
    {
        super(IMG_PATH, 0, 0, 64, 64);

        this.speed = 6.0;
        this.type = this.type.Enemy;
    }

    /**
     * Collide with an entity, destroy almost everything
     */

    override public void collide ( Entity other )
    {
        if ( other.type != other.type.Background )
        {
            other.kill();

            if ( other.type == other.type.Player )
            {
                World().player.health = 0;
            }
        }
    }
}
