/**
 * Base class for an animated entity, a sprite entity with multiple frames
 */

module game.entity.model.AnimatedEntity;

import game.entity.model.SpriteEntity;

import util.GL;

/**
 * Animated entity base class
 */

public class AnimatedEntity : SpriteEntity
{
    /**
     * The number of frames to animate
     */

    private uint frames;

    /**
     * The current frame
     */

    private uint cur_frame;

    /**
     * The animation speed in ms per frame
     */

    private uint anim_speed;

    /**
     * The number of elapsed milliseconds since the last frame switch
     */

    private uint elapsed;

    /**
     * Constructor
     *
     * Params:
     *      frames = The number of frames in the animation
     *      speed = The animation speed in ms per frame
     *      path = The path to the sprite image
     *      x = The starting x coordinate
     *      y = The starting y coordinate
     *      width = The width
     *      height = The height
     */

    public this ( uint frames, uint anim_speed, string path, float x, float y, float width, float height )
    {
        super(path, x, y, width, height);

        this.frames = frames;
        this.anim_speed = anim_speed;

        this.cur_frame = 1;
    }

    /**
     * Invariant, makes sure the current frame is sensible
     */

    invariant ( )
    {
        assert(this.cur_frame > 0 && this.cur_frame <= this.frames);
    }

    /**
     * Draw the animated entity using the sprite at the current frame
     */

    override public void draw ( )
    {
        // Get the texture x coordinates based on the current frame
        auto s_min = cast(float)(this.cur_frame - 1) / frames;
        auto s_max = cast(float)this.cur_frame / frames;

        GL.enable(GL.TEXTURE_2D);
        GL.bindTexture(this.texture.handle);
        GL.begin(GL.QUADS);
        GL.texCoord2f(s_min, 0);
        GL.vertex2f(this.x, this.y);
        GL.texCoord2f(s_max, 0);
        GL.vertex2f(this.x + this.width, this.y);
        GL.texCoord2f(s_max, 1);
        GL.vertex2f(this.x + this.width, this.y + this.height);
        GL.texCoord2f(s_min, 1);
        GL.vertex2f(this.x, this.y + this.height);
        GL.end();
        GL.disable(GL.TEXTURE_2D);
    }

    /**
     * Override the move method to update the current frame
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last move
     */

    override public void move ( uint ms )
    {
        super.move(ms);

        this.elapsed += ms;

        if ( this.elapsed > this.anim_speed )
        {
            this.nextFrame();
            this.elapsed -= this.anim_speed;
        }
    }

    /**
     * Move to the next animation frame
     */

    private void nextFrame ( )
    {
        this.cur_frame = this.cur_frame == this.frames ? 1 : this.cur_frame + 1;
    }
}
