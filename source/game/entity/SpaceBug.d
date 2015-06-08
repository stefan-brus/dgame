/**
 * Space bug enemy entity
 */

module game.entity.SpaceBug;

import game.entity.model.AnimatedEntity;
import game.entity.model.Direction;
import game.entity.model.Entity;
import game.world.World;
import game.SoundLib;

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
        this.type = this.type.Enemy;
    }

    /**
     * Collide with an entity, kill the bug if it's a shot
     *
     * Params:
     *      other = The other entity
     */

    override public void collide ( Entity other )
    {
        if ( other.type == other.type.Shot )
        {
            SoundLib().play(SoundLib.HIT);

            World().player.score++;
            World().quests.enemyKilled(Enemies.SpaceBug);

            this.kill();
        }
    }
}
