/**
 * The player entity
 */

module game.entity.Player;

import game.entity.model.Direction;
import game.entity.model.Entity;
import game.entity.model.SpriteEntity;
import game.entity.ShotGenerator;
import game.entity.PlasmaShot;
import game.world.World;
import game.SoundLib;

/**
 * Player entity class
 */

public class Player : SpriteEntity
{
    /**
     * The path to the sprite image
     */

    public static enum IMG_PATH = "res/player.png";

    /**
     * Whether or not the player is shooting
     */

    public bool is_shooting;

    /**
     * The shot generator
     */

    public ShotGenerator!PlasmaShot shots;

    /**
     * The invulnerability time counter
     */

    private uint invul_time;

    private static enum INVUL_MAX = 2000;

    /**
     * Constructor
     *
     * Params:
     *      width = The game world width
     *      height = The game world height
     */

    public this ( int width, int height )
    {
        super(IMG_PATH, 200, 200, 64, 64);

        this.speed = 4.0;
        this.type = Entity.Type.PLAYER;
        this.shots = new ShotGenerator!PlasmaShot(width, height, 5, DIR_UP);
    }

    /**
     * Override the draw function to draw the shots first
     */

    override public void draw ( )
    {
        this.shots.draw();

        super.draw();
    }

    /**
     * Override the collide function, do nothing for now
     *
     * Params:
     *      other = unused
     */

    override public void collide ( Entity other )
    {
        if ( other.type == Entity.Type.ENEMY && invul_time == 0 )
        {
            SoundLib().play(SoundLib.DEAD);
            World().player.health--;
            this.invul_time++;
        }
    }

    /**
     * Update the player entity state
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last update
     */

    public void update ( uint ms )
    {
        if ( this.invul_time > 0 && this.invul_time < INVUL_MAX )
        {
            this.invul_time += ms;
        }
        else
        {
            this.invul_time = 0;
        }
    }

    /**
     * Check whether to fire a shot, and update the shot generator
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last shot
     */

    public void shoot ( uint ms )
    {
        if ( this.is_shooting )
        {
            this.shots.shoot(this.x + 5, this.y);
            this.shots.shoot(this.x + this.width - 8, this.y);
            this.shots.reset();
        }

        this.shots.update(ms);
    }
}
