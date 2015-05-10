/**
 * Queue data structure
 */

module util.container.Queue;

import std.exception;

/**
 * Queue class
 *
 * Only works with objects for now
 *
 * Template params:
 *      T = The type to store in the Queue
 */

public class Queue ( T )
{
    static assert(is(T == class));

    /**
     * Array of items
     */

     private T[] items;

     /**
      * Add an item to the back of the queue
      *
      * Params:
      *     item = The item to add
      */

    public void add ( T item )
    {
        this.items ~= item;
    }

    /**
     * Remove the item at the front of the queue
     *
     * Returns:
     *      The item at the front of the queue, or null if queue is empty
     */

    public T remove ( )
    {
        if ( this.empty() )
        {
            return null;
        }

        auto res = this.items[0];

        this.items = this.items[1 .. $];

        return res;
    }

    /**
     * Check if the queue is empty
     *
     * Returns:
     *      True if queue is empty
     */

    public bool empty ( )
    {
        return this.items.length == 0;
    }
}

unittest
{
    class TestItem
    {
        int n;

        this ( int n )
        {
            this.n = n;
        }
    }

    auto queue = new Queue!TestItem();

    assert(queue.empty());

    queue.add(new TestItem(3));
    assert(!queue.empty());
    assert(queue.remove().n == 3);
    assert(queue.empty());

    queue.add(new TestItem(1));
    queue.add(new TestItem(2));
    queue.add(new TestItem(3));
    assert(!queue.empty());
    assert(queue.remove().n == 1);
    assert(queue.remove().n == 2);
    assert(queue.remove().n == 3);
    assert(queue.empty());
}
