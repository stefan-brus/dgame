/**
 * Base class for a game entity
 */

module game.entity.model.Entity;

import game.entity.model.Direction;
import game.Config;

/**
 * Entity base class
 */

public abstract class Entity
{
    /**
     * What kind of entity this is
     */

    public enum Type {
        Background, // Background entity, default value
        Player,     // Player entity
        Enemy,      // Enemy entity
        Shot        // Shot entity
    }

    public Type type;

    /**
     * The coordinates of the entity's upper left corner
     */

    protected float x;
    protected float y;

    /**
     * The size of the entity
     */

    public float width;
    public float height;

    /**
     * The entity's speed
     */

    protected float speed = 0.0;

    /**
     * The entity's direction
     */

    public Directions dir;

    /**
     * Constructor
     *
     * Params:
     *      x = The starting x coordinate
     *      y = The starting y coordinate
     *      width = The width
     *      height = The height
     */

    public this ( float x, float y, float width, float height )
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    /**
     * Override this, draw the entity
     */

    public abstract void draw ( );

    /**
     * Override this, collide with another entity
     *
     * Params:
     *      other = The other entity
     */

    public abstract void collide ( Entity other );

    /**
     * Move the entity according to its speed and directions
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last move
     */

    public void move ( uint ms )
    {
        auto distance = this.speed * ms / Config.MS_PER_FRAME;

        with ( Direction )
        {
            this.y -= this.dir[Up] ? distance : 0;
            this.x -= this.dir[Left] ? distance : 0;
            this.y += this.dir[Down] ? distance : 0;
            this.x += this.dir[Right] ? distance : 0;
        }
    }

    /**
     * Set the position of this entity
     *
     * Params:
     *      x = The new x position
     *      y = The new y position
     */

    public void setPos ( float x, float y )
    {
        this.x = x;
        this.y = y;
    }

    /**
     * Get the directions this entity can move in based on the given boundaries
     *
     * Params:
     *      w = The width to check against
     *      h = The height to check against
     *
     * Returns:
     *      A set of directions based on the given boundaries
     */

    public Directions getBoundaries ( int w, int h )
    in
    {
        assert(w >= 0 && h >= 0);
    }
    body
    {
        Directions dirs;

        with ( Direction )
        {
            dirs[Up] = this.y > 0;
            dirs[Left] = this.x > 0;
            dirs[Down] = h > this.y + this.height;
            dirs[Right] = w > this.x + this.width;
        }

        return dirs;
    }

    /**
     * Check if this entity is out of bounds
     *
     * Params:
     *      w = The width to check against
     *      h = The height to check against
     *
     * Returns:
     *      True if this entity is out of bounds
     */

    public bool outOfBounds ( int w, int h )
    {
        auto x1 = this.x, x2 = this.x + this.width,
             y1 = this.y, y2 = this.y + this.height;

        return x1 > w || x2 < 0 || y1 > h || y2 < 0;
    }

    /**
     * Collision check every entity in the given arrays
     *
     * Template params:
     *      T1 = The type of the first entities
     *      T2 = The type of the second entities
     *
     * Params:
     *      es1 = The first entity array
     *      es2 = The second entity array
     *      dg = Optional, the delegate function to call when a collision is detected
     */

    alias CollideDg = void delegate ( Entity e1, Entity e2 );
    public static void checkCollisions ( T1 : Entity, T2 : Entity ) ( T1[] es1, T2[] es2, CollideDg dg = null )
    {
        foreach ( e1; es1 )
        {
            foreach ( e2; es2 )
            {
                if ( e1.checkCollision(e2) )
                {
                    e1.collide(e2);
                    e2.collide(e1);

                    if ( dg !is null )
                    {
                        dg(e1, e2);
                    }
                }
            }
        }
    }

    /**
     * Kill this entity
     *
     * For now, sends it off screen based on its direction
     */

    public void kill ( )
    {
        with ( Direction )
        {
            enum OFFSET = 10000;

            this.y += this.dir[Up] ? OFFSET : 0;
            this.x -= this.dir[Left] ? OFFSET : 0;
            this.y -= this.dir[Down] ? OFFSET : 0;
            this.x += this.dir[Right] ? OFFSET : 0;
        }
    }

    /**
     * Check if this entity and the given one collide (rectangles overlap)
     *
     * Params:
     *      other = The other entity
     *
     * Returns:
     *      True if rectangles overlap
     */

    private bool checkCollision ( Entity other )
    {
        auto r1_x1 = this.x, r1_x2 = this.x + this.width,
             r1_y1 = this.y, r1_y2 = this.y + this.height,
             r2_x1 = other.x, r2_x2 = other.x + other.width,
             r2_y1 = other.y, r2_y2 = other.y + other.height;

        if ( r1_x1 > r2_x2 || r1_x2 < r2_x1 ||
             r1_y1 > r2_y2 || r1_y2 < r2_y1 )
        {
            return false;
        }
        else
        {
            return true;
        }
    }
}
