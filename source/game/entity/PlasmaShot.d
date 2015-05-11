/**
 * Plasma shot entity
 */

module game.entity.PlasmaShot;

import game.entity.model.Entity;

import util.GL;

/**
 * Plasma shot entity class
 */

public class PlasmaShot : Entity
{
    /**
     * Constructor
     *
     * Create a plasma shot at the top left corner, use setPos to move it
     */

    public this ( )
    {
        super(0, 0, 5, 5);

        this.speed = 8.0;
    }

    /**
     * Draw the plasma shot, currently a red square
     */

    override public void draw ( )
    {
        GL.begin(GL.QUADS);
        GL.color3ub(0xFF, 0x00, 0x00);
        GL.vertex2f(this.x, this.y);
        GL.vertex2f(this.x + this.width, this.y);
        GL.vertex2f(this.x + this.width, this.y + this.height);
        GL.vertex2f(this.x, this.y + this.height);
        GL.color3ub(0xFF, 0xFF, 0xFF);
        GL.end();
    }
}
