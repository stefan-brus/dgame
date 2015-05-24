/**
 * Math utilities
 */

module util.Math;

/**
 * Math functions wrapper struct
 */

public struct Math
{
    /**
     * Find the next power of 2 for the given number
     *
     * Params:
     *      n = The number
     *
     * Returns:
     *      The next power of 2
     */

    public static int nextPowerOf2 ( int n )
    in
    {
        assert(n > 0);
    }
    body
    {
        static uint[] powers = [1, 2];

        bool new_max;

        while ( n > powers[$ - 1] )
        {
            new_max = true;
            powers ~= powers[$ - 1] * 2;
        }

        if ( !new_max ) foreach ( p; powers )
        {
            if ( n <= p )
            {
                return p;
            }
        }

        return powers[$ - 1];
    }

    unittest
    {
        assert(nextPowerOf2(1) == 1);
        assert(nextPowerOf2(2) == 2);
        assert(nextPowerOf2(3) == 4);
        assert(nextPowerOf2(4) == 4);
        assert(nextPowerOf2(15) == 16);
        assert(nextPowerOf2(128) == 128);
        assert(nextPowerOf2(257) == 512);
    }
}
