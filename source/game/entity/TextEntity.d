/**
 * An entity that displays text
 */

module game.entity.TextEntity;

import game.entity.model.Entity;
import game.entity.model.SpriteEntity;

import util.GL;
import util.Math;
import util.SDL;

import std.exception;

/**
 * Text entity class
 */

public class TextEntity : SpriteEntity
{
    /**
     * The font to render text with
     */

    private static SDL.TTF.Font FONT;

    private static enum FONT_PATH = "res/ariblk.ttf";

    /**
     * The path to the created texture
     */

    private string path;

    /**
     * The text color
     */

    private SDL.Color color;

    /**
     * Constructor
     *
     * Params:
     *      text = The text to display
     *      color = The text color
     *      x = The starting x coordinate
     *      y = The starting y coordinate
     */

    public this ( string text, SDL.Color color, float x, float y )
    {
        this.color = color;

        this.setText(text);

        super(this.path, x, y, this.width, this.height);
    }

    /**
     * Collide, do nothing
     *
     * Params:
     *      other = The other entity
     */

    override public void collide ( Entity other )
    {

    }

    /**
     * Set the text
     */

    public void setText ( string text )
    {
        this.path = "__TEXT__" ~ text;

        this.texture = this.path in LOADED_TEXTURES ? LOADED_TEXTURES[path] : createTexture(text, this.color, this.path);

        this.width = this.texture.width;
        this.height = this.texture.height;
    }

    /**
     * Create a texture displaying the given text
     * Store it in the given path
     *
     * Params:
     *      text = The text to display
     *      color = The text color
     *      path = The path to store the texture in
     *
     * Returns:
     *      The texture handle
     */

    private static GL.Texture createTexture ( string text, SDL.Color color, string path )
    {
        if ( FONT == FONT.init )
        {
            FONT = SDL.TTF.openFont(FONT_PATH, 16);
            enforce(FONT() !is null, "Unable to load font: " ~ FONT_PATH);
        }

        auto surface = SDL.TTF.renderTextBlended(FONT, text, color);
        enforce(surface() !is null, "Failed to load text: " ~ text);

        // Make sure image has an alpha channel
        enforce(surface().format.BytesPerPixel == 4, "Texture must have an alpha channel");

        // Resize the texture so its dimensions are powers of 2
        auto width = Math.nextPowerOf2(surface().w);
        auto height = Math.nextPowerOf2(surface().h);
        auto resized = SDL.Surface.createRGBASurface(width, height);
        SDL.Surface.blitSurface(surface, resized);

        auto handle = GL.genTexture();
        GL.bindTexture(handle);
        GL.texParameteri(GL.TEXTURE_MIN_FILTER, GL.LINEAR);
        GL.texParameteri(GL.TEXTURE_MAG_FILTER, GL.LINEAR);
        GL.texImage2D(width, height, resized().pixels);

        auto result = GL.Texture(handle, width, height);
        LOADED_TEXTURES[path] = result;

        SDL.Surface.freeSurface(surface);
        SDL.Surface.freeSurface(resized);

        return result;
    }
}
