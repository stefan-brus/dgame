/**
 * Base class for an entity with a sprite image loaded from disk
 */

module game.entity.model.SpriteEntity;

import game.entity.model.Entity;

import util.GL;
import util.SDL;

import std.exception;

/**
 * Sprite entity base class
 */

public abstract class SpriteEntity : Entity
{
    /**
     * Texture handles to textures that have already been loaded
     */

    private static uint[string] LOADED_TEXTURES;

    /**
     * The texture handle
     */

    protected uint texture;

    /**
     * Constructor
     *
     * Params:
     *      path = The path to the sprite image
     *      x = The starting x coordinate
     *      y = The starting y coordinate
     *      width = The width
     *      height = The height
     */

    public this ( string path, float x, float y, float width, float height )
    {
        super(x, y, width, height);

        if ( path !in LOADED_TEXTURES )
        {
            this.loadTexture(path);
        }
        else
        {
            this.texture = LOADED_TEXTURES[path];
        }
    }

    /**
     * Draw the sprite entity
     */

    override public void draw ( )
    {
        GL.enable(GL.TEXTURE_2D);
        GL.bindTexture(this.texture);
        GL.begin(GL.QUADS);
        GL.texCoord2i(0, 0);
        GL.vertex2f(this.x, this.y);
        GL.texCoord2i(1, 0);
        GL.vertex2f(this.x + this.width, this.y);
        GL.texCoord2i(1, 1);
        GL.vertex2f(this.x + this.width, this.y + this.height);
        GL.texCoord2i(0, 1);
        GL.vertex2f(this.x, this.y + this.height);
        GL.end();
        GL.disable(GL.TEXTURE_2D);
    }

    /**
     * Helper function to load a texture using the image at the given path
     *
     * Stores the texture handle in this.texture for future use
     * The width and height of the image must be a power of 2, and color depth must be 32 bit
     *
     * Params:
     *      path = The path to the image
     */

    private void loadTexture ( string path )
    {
        auto surface = SDL.imgLoad(path);
        enforce(surface() !is null, "Failed to load image at " ~ path);

        // Make sure image height and width is a power of 2 using magic hackery
        enforce((surface().w & (surface().w - 1)) == 0, "Texture width must be a power of 2");
        enforce((surface().h & (surface().h - 1)) == 0, "Texture height must be a power of 2");

        // Make sure image has an alpha channel
        enforce(surface().format.BytesPerPixel == 4, "Texture must have an alpha channel");

        this.texture = GL.genTexture();
        GL.bindTexture(this.texture);
        GL.texParameteri(GL.TEXTURE_MIN_FILTER, GL.LINEAR);
        GL.texParameteri(GL.TEXTURE_MAG_FILTER, GL.LINEAR);
        GL.texImage2D(surface().w, surface().h, surface().pixels);
        LOADED_TEXTURES[path] = this.texture;

        SDL.Surface.freeSurface(surface);
    }
}
