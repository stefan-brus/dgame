/**
 * SDL application class
 */

module game.SDLApp;

import game.model.IGame;

import util.GL;
import util.SDL;

import std.stdio;

/**
 * SDLApp class
 */

public class SDLApp
{
    /**
     * Frames per second
     */

    private enum FPS = 75;

    /**
     * The SDL window
     */

    private SDL.Window win;

    /**
     * The SDL window's surface
     */

    private SDL.Surface surface;

    /**
     * The OpenGL context
     */

    private SDL.GL gl_context;

    /**
     * Game reference
     */

    private IGame game;

    /**
     * Window width
     */

    private int width;

    /**
     * Window height
     */

    private int height;

    /**
     * Number of elapsed ticks since SDL was initialized
     */

    private uint ticks = 0;

    /**
     * The running state of the app
     */

    private bool running;

    /**
     * Constructor
     *
     * Creates the SDL window with the given name and runs the given game
     *
     * Params:
     *      name = The name of the app
     *      width = The width of the app's window
     *      height = The height of the app's window
     *      game = The game to run
     */

    public this ( string name, int width, int height, IGame game )
    {
        this.win = SDL.Window.createWindow(name, width, height);
        if ( this.win() is null )
        {
            logSDLError("Error creating window");
            assert(false);
        }

        this.width = width;
        this.height = height;

        this.surface = SDL.Surface.getWindowSurface(this.win);
        if ( this.surface() is null )
        {
            logSDLError("Error getting window surface");
            SDL.Window.destroyWindow(this.win);
            assert(false);
        }

        this.gl_context = SDL.GL.getContext(this.win);
        if ( this.gl_context() is null )
        {
            logSDLError("Error creating SDL GL context");
            SDL.Window.destroyWindow(this.win);
            assert(false);
        }

        this.setupOpenGL();

        this.game = game;
    }

    /**
     * Destructor
     *
     * Destroys the SDL window
     */

    ~this ( )
    {
        SDL.GL.deleteContext();
        SDL.Window.destroyWindow(this.win);
    }

    /**
     * Static constructor
     *
     * Initializes SDL
     */

    static this ( )
    {
        if ( !SDL.init() )
        {
            logSDLError("Error initializing SDL");
            assert(false);
        }

        if ( !SDL.initGL() )
        {
            logSDLError("Error initializing SDL GL");
            assert(false);
        }
    }

    /**
     * Static destructor
     *
     * De-init SDL
     */

    static ~this ( )
    {
        SDL.quit();
    }

    /**
     * Run the app's main loop
     *
     * Returns:
     *      0, or an error code
     */

    public int run ( )
    in
    {
        assert(this.win() && this.surface());
    }
    body
    {
        this.running = true;

        auto event = SDL.Event.createEvent();

        try
        {
            this.game.init();

            while ( this.running )
            {
                while ( SDL.Event.pollEvent(event) )
                {
                    if ( event().type == SDL.Event.QUIT )
                    {
                        this.running = false;
                        break;
                    }
                }

                if ( !this.game.handle(event) )
                {
                    logSDLError("Error handling event");
                    return 1;
                }

                this.game.step();
                this.game.render();
                SDL.GL.swapWindow(this.win);

                auto elapsed = this.elapsedTicks();

                if ( elapsed < 1000 / FPS )
                {
                    SDL.delay(1000 / FPS - elapsed);
                }

                this.ticks += elapsed;
            }
        }
        catch ( Exception e )
        {
            logSDLError("Exception caught in main loop: " ~ e.msg);
            return 1;
        }

        return 0;
    }

    /**
     * Get the number of elapsed ticks since the last check
     *
     * Returns:
     *      The number of elapsed ticks
     */

    private uint elapsedTicks ( )
    {
        return SDL.getTicks() - this.ticks;
    }

    /**
     * Helper function to set up initial OpenGL state
     */

    private void setupOpenGL ( )
    {
        SDL.GL.setSwapInterval(1);

        GL.clearColor(0.0, 0.0, 0.0, 0.0);
        GL.enable(GL.TEXTURE_2D);
        GL.enable(GL.BLEND);
        GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
        GL.matrixMode(GL.PROJECTION);
        GL.loadIdentity();
        GL.ortho(0.0, this.width, this.height, 1.0, -1.0, 1.0);
    }

    /**
     * Log an SDL error with the given message
     *
     * Params:
     *      msg = The error message
     */

    private static void logSDLError ( string msg )
    {
        writefln("Error: %s", msg);
        writefln("SDL Error: %s", SDL.error());
    }
}
