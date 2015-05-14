/**
 * Star entity
 */

module game.entity.Star;

import game.entity.model.Entity;

import util.GL;

import std.random;

/**
 * Star entity class
 */

public class Star : Entity
{
    /**
     * Struct to hold RGBA color values
     */

    private struct Color
    {
        ubyte r;
        ubyte g;
        ubyte b;
        ubyte a;
    }

    private Color color;

    /**
     * Constructor
     *
     * Create a star at the top left corner, use setPos to move it
     */

    public this ( )
    {
        super(0, 0, 1, 1);
    }

    /**
     * Draw the star
     */

    override public void draw ( )
    {
        GL.begin(GL.QUADS);
        GL.color4ub(this.color.r, this.color.g, this.color.b, this.color.a);
        GL.vertex2f(this.x, this.y);
        GL.vertex2f(this.x + this.width, this.y);
        GL.vertex2f(this.x + this.width, this.y + this.height);
        GL.vertex2f(this.x, this.y + this.height);
        GL.color4ub(0xFF, 0xFF, 0xFF, 0xFF);
        GL.end();
    }

    /**
     * Collide with an entity, do nothing
     *
     * Params:
     *      other = unused
     */

    override public void collide ( Entity other )
    {

    }

    /**
     * Generate a new color
     */

    public void generateColor ( )
    {
        // Color range constants
        enum RED_MIN = 212, RED_MAX = 236;
        enum GREEN_MIN = 183, GREEN_MAX = 200;
        enum BLUE_MIN = 69, BLUE_MAX = 86;

        this.color.r = cast(ubyte)uniform(RED_MIN, RED_MAX);
        this.color.g = cast(ubyte)uniform(GREEN_MIN, GREEN_MAX);
        this.color.b = cast(ubyte)uniform(BLUE_MIN, BLUE_MAX);
    }

    /**
     * Generate a new speed
     *
     * Also generates a new alpha value based on the new speed
     */

    public void generateSpeed ( )
    {
        auto factor = uniform01();

        this.speed = factor * 0.4;
        this.color.a = cast(ubyte)(factor * ubyte.max);
    }
}
