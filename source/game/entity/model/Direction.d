/**
 * Direction types and helper functions
 */

module game.entity.model.Direction;

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
    Direction.LEFT: false,
    Direction.DOWN: false,
    Direction.RIGHT: false
];

public enum Directions DIR_DOWN = [
    Direction.UP: false,
    Direction.LEFT: false,
    Direction.DOWN: true,
    Direction.RIGHT: false
];

public enum Directions DIR_LEFT = [
    Direction.UP: false,
    Direction.LEFT: true,
    Direction.DOWN: false,
    Direction.RIGHT: false
];

public enum Directions DIR_RIGHT = [
    Direction.UP: false,
    Direction.LEFT: false,
    Direction.DOWN: false,
    Direction.RIGHT: true
];

/**
 * Helper function to get the intersection of 2 sets of directions
 *
 * Params:
 *      d1 = The first set of directions
 *      d2 = The second set of directions
 *
 * Returns:
 *      The intersection of d1 and d2
 */

public Directions intersectDirs ( Directions d1, Directions d2 )
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

/**
 * Check if a set of directions isn't going anywhere
 *
 * Params:
 *      dirs = The directions to check
 *
 * Returns:
 *      True if all directions in the given set are false
 */

public bool still ( Directions dirs )
{
    with ( Direction )
    {
        return !dirs[UP] && !dirs[LEFT] && !dirs[DOWN] && !dirs[RIGHT];
    }
}
