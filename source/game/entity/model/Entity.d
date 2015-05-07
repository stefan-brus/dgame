/**
 * Base class for a game entity
 */

module game.entity.model.Entity;

/**
 * Entity base class
 */

public abstract class Entity
{
    /**
     * Type to handle the direction of an entity
     */

    public enum Direction {
        UP,
        LEFT,
        DOWN,
        RIGHT
    }

    public alias bool[Direction] Directions;

    /**
     * Direction constants
     */

    public enum Directions DIR_UP = [
        Direction.UP: true,
        Direction.DOWN: false,
        Direction.LEFT: false,
        Direction.RIGHT: false
    ];

    /**
     * The coordinates of the entity's upper left corner
     */

    protected float x;
    protected float y;

    /**
     * The size of the entity
     */

    protected float width;
    protected float height;

    /**
     * The entity's speed
     */

    protected float speed = 0.0;

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
     * Move the entity according to its speed and the given directions
     *
     * Params:
     *      dirs = The directions
     */

    public void move ( Directions dirs )
    {
        with ( Direction )
        {
            this.y -= dirs[UP] ? this.speed : 0;
            this.x -= dirs[LEFT] ? this.speed : 0;
            this.y += dirs[DOWN] ? this.speed : 0;
            this.x += dirs[RIGHT] ? this.speed : 0;
        }
    }

    /**
     * Get the directions this entity can move in based on the given boundaries
     *
     * Params:
     *      w = The width to check against
     *      w = The height to check against
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
            dirs[UP] = this.y > 0;
            dirs[LEFT] = this.x > 0;
            dirs[DOWN] = h > this.y + this.height;
            dirs[RIGHT] = w > this.x + this.width;
        }

        return dirs;
    }

    /**
     * Helper function to get the intersection of 2 sets of directions
     */

    public static Directions intersectDirs ( Directions d1, Directions d2 )
    {
        Directions dirs;

        with ( Direction )
        {
            dirs[UP] = d1[UP] && d2[UP];
            dirs[LEFT] = d1[LEFT] && d2[LEFT];
            dirs[DOWN] = d1[DOWN] && d2[DOWN];
            dirs[RIGHT] = d1[RIGHT] && d2[RIGHT];
        }

        return dirs;
    }
}
