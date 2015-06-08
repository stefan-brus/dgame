/**
 * Direction types and helper functions
 */

module game.entity.model.Direction;

/**
 * Type to handle the direction of an entity
 */

public enum Direction {
    Up,
    Left,
    Down,
    Right
}

public alias bool[Direction] Directions;

/**
 * Direction constants
 */

public enum Directions DIR_UP = [
    Direction.Up: true,
    Direction.Left: false,
    Direction.Down: false,
    Direction.Right: false
];

public enum Directions DIR_DOWN = [
    Direction.Up: false,
    Direction.Left: false,
    Direction.Down: true,
    Direction.Right: false
];

public enum Directions DIR_LEFT = [
    Direction.Up: false,
    Direction.Left: true,
    Direction.Down: false,
    Direction.Right: false
];

public enum Directions DIR_RIGHT = [
    Direction.Up: false,
    Direction.Left: false,
    Direction.Down: false,
    Direction.Right: true
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
        dirs[Up] = d1[Up] && d2[Up];
        dirs[Left] = d1[Left] && d2[Left];
        dirs[Down] = d1[Down] && d2[Down];
        dirs[Right] = d1[Right] && d2[Right];
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
        return !dirs[Up] && !dirs[Left] && !dirs[Down] && !dirs[Right];
    }
}
