/**
 * Entity generator
 *
 * Use an object pool to generate many instances of an entity
 */

module game.entity.model.Generator;

import game.entity.model.Entity;

import util.container.ObjectPool;

import std.algorithm;

/**
 * Generator class
 *
 * Template params:
 *      T = The type object to generate, must be an entity
 */

public abstract class Generator ( T : Entity )
{
    /**
     * Pool of entities
     */

    protected ObjectPool!T pool;

    /**
     * References to currently active entities
     */

    protected T[] active;

    /**
     * Constructor
     */

    public this ( )
    {
        this.pool = new ObjectPool!T();
    }

    /**
     * Override this, update the active entities
     */

    public abstract void update ( );

    /**
     * Override this, draw the active entities
     */

    public abstract void draw ( );

    /**
     * Generate an entity and create a reference to it
     *
     * Returns:
     *      A reference to the generated entity
     */

    protected T generate ( )
    {
        auto entity = this.pool.get();
        this.active ~= entity;

        return entity;
    }

    /**
     * Recycle an entity and remove the reference to it
     *
     * Params:
     *      idx = The index of the object in this.active
     */

    protected void recycle ( size_t idx )
    in
    {
        assert(idx < this.active.length);
    }
    body
    {
        auto item = this.active[idx];
        this.pool.put(item);
        this.active = remove(this.active, idx);
    }
}
