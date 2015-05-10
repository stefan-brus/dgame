/**
 * Object pool (not really) data structure
 */

module util.container.ObjectPool;

import util.container.Queue;

/**
 * Object pool class
 *
 * Template params:
 *      T = The type to store in the pool
 */

public class ObjectPool ( T )
{
    /**
     * Queue of objects to use
     */

     private Queue!T queue;

     /**
      * Constructor
      */

    public this ( )
    {
        this.queue = new Queue!T();
    }

     /**
      * Get an object from the pool
      *
      * Returns:
      *     The item at the front of the queue, or a new one if empty
      */

    public T get ( )
    {
        if ( this.queue.empty() )
        {
            return new T();
        }
        else
        {
            return this.queue.remove();
        }
    }

    /**
     * Put an object back into the pool
     *
     * Params:
     *      obj = The object to put back
     */

    public void put ( T obj )
    {
        this.queue.add(obj);
    }
}
