/**
 * Star entity
 */

module game.entity.Star;

import game.entity.model.Entity;

import util.GL;

/**
 * Star entity class
 */

public class Star : Entity
{
    /**
     * Constructor
     *
     * Create a star at the top left corner, use setPos to move it
     */

    public this ( )
    {
        super(0, 0, 2, 2);

        this.speed = 0.1;
    }

    /**
     * Draw the star
     */

    override public void draw ( )
    {
        GL.begin(GL.QUADS);
        GL.color3ub(0xFF, 0xFF, 0xFF);
        GL.vertex2f(this.x, this.y);
        GL.vertex2f(this.x + this.width, this.y);
        GL.vertex2f(this.x + this.width, this.y + this.height);
        GL.vertex2f(this.x, this.y + this.height);
        GL.end();
    }
}
