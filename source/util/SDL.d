/**
 * SDL Utilities
 *
 * Wrapper structs and utility functions
 */

module util.SDL;

import derelict.opengl3.gl; // This module is needed because reload() needs to be called after the context is created
import derelict.sdl2.sdl;

import std.conv;
import std.string;

/**
 * SDL functions namespace struct wrapper
 */

public struct SDL
{
    /**
     * SDL window wrapper struct
     */

    public struct Window
    {
        /**
         * The SLD_Window pointer
         */

        private SDL_Window* sdl_win;

        /**
         * opCall
         *
         * Params:
         *      sdl_win = If not null, sets sdl_win to this pointer
         *
         * Returns:
         *      The SDL_Window pointer
         */

        public SDL_Window* opCall ( SDL_Window* sdl_win = null )
        {
            if ( sdl_win !is null )
            {
                this.sdl_win = sdl_win;
            }

            return this.sdl_win;
        }

        /**
         * Create an SDL window
         *
         * Does not check if the created window is null or not
         *
         * Params:
         *      name = The name of the window
         *      width = The window width
         *      height = The window height
         *
         * Returns:
         *      The created window wrapped in a struct
         */

        public static Window createWindow ( string name, int width, int height )
        {
            Window result;

            result(SDL_CreateWindow(toStringz(name), 100, 100, width, height, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN));

            return result;
        }

        /**
         * Destroy a given SDL window
         *
         * Params:
         *      win = The SDL window to destroy
         */

        public static void destroyWindow ( Window win )
        {
            SDL_DestroyWindow(win());
        }

        /**
         * Update a given SDL window
         */

        public static void updateWindow ( Window win )
        {
            SDL_UpdateWindowSurface(win());
        }
    }

    /**
     * SDL surface wrapper struct
     */

    public struct Surface
    {
        /**
         * The SLD_Surface pointer
         */

        private SDL_Surface* sdl_surface;

        /**
         * opCall
         *
         * Params:
         *      sdl_surface = If not null, sets sdl_surface to this pointer
         *
         * Returns:
         *      The SDL_Surface pointer
         */

        public SDL_Surface* opCall ( SDL_Surface* sdl_surface = null )
        {
            if ( sdl_surface !is null )
            {
                this.sdl_surface = sdl_surface;
            }

            return this.sdl_surface;
        }

        /**
         * Get the surface of a given SDL window
         *
         * Params:
         *      win = The SDL window
         */

        public static Surface getWindowSurface ( Window win )
        {
            Surface result;

            result(SDL_GetWindowSurface(win()));

            return result;
        }

        /**
         * Free the given surface
         *
         * Params:
         *      surface = The surface to free
         */

        public static void freeSurface ( Surface surface )
        {
            SDL_FreeSurface(surface());
        }
    }

    /**
     * SDL event wrapper struct
     */

    public struct Event
    {
        /**
         * SDL event constants
         */

        public static const QUIT = SDL_QUIT;
        public static const KEYDOWN = SDL_KEYDOWN;
        public static const KEY_W = SDLK_w;
        public static const KEY_A = SDLK_a;
        public static const KEY_S = SDLK_s;
        public static const KEY_D = SDLK_d;

        /**
         * The SDL_Event pointer
         */

        private SDL_Event* sdl_event;

        /**
         * opCall
         *
         * Params:
         *      sdl_event = If not null, sets sdl_event to this pointer
         *
         * Returns:
         *      The SDL_Event pointer
         */

        public SDL_Event* opCall ( SDL_Event* sdl_event = null )
        {
            if ( sdl_event !is null )
            {
                this.sdl_event = sdl_event;
            }

            return this.sdl_event;
        }

        /**
         * Create an SDL event struct
         *
         * Returns:
         *      The created event struct
         */

        public static Event createEvent ( )
        {
            auto sdl_event = new SDL_Event;
            Event result;

            result(sdl_event);

            return result;
        }

        /**
         * Poll the SDL event queue
         *
         * Params:
         *      event = The event to store what is popped from the queue in
         *
         * Returns:
         *      True if there was a pending event, false otherwise
         */

        public static bool pollEvent ( ref Event event )
        {
            if ( SDL_PollEvent(event()) == 0 )
            {
                return false;
            }

            return true;
        }
    }

    /**
     * SDL GL context wrapper struct
     */

    public struct GL
    {
        /**
         * SDL GL constants
         */

        public static const CONTEXT_MAJOR_VERSION = SDL_GL_CONTEXT_MAJOR_VERSION;
        public static const CONTEXT_MINOR_VERSION = SDL_GL_CONTEXT_MINOR_VERSION;
        public static const DOUBLEBUFFER = SDL_GL_DOUBLEBUFFER;
        public static const DEPTH_SIZE = SDL_GL_DEPTH_SIZE;

        /**
         * SDL_GLContext pointer
         *
         * Static, as there can only be one
         */

        private static SDL_GLContext* sdl_glcontext = null;

        /**
         * opCall
         *
         * Returns:
         *      The SDL_GLContext pointer
         */

        public SDL_GLContext* opCall ( )
        {
            return sdl_glcontext;
        }

        /**
         * Get the SDL GL context
         *
         * Params:
         *      win = The window to create the context from
         *
         * Returns:
         *      The GL context
         */

        public static GL getContext ( Window win )
        {
            if ( sdl_glcontext is null )
            {
                auto ctx = SDL_GL_CreateContext(win());
                sdl_glcontext = &ctx;
                DerelictGL.reload();
            }

            GL result;

            return result;
        }

        /**
         * Delete the SDL GL context
         */

        public static void deleteContext ( )
        in
        {
            assert(sdl_glcontext !is null);
        }
        body
        {
            SDL_GL_DeleteContext(*sdl_glcontext);
        }

        /**
         * Set an SDL GL attribute
         *
         * Params:
         *      attr = The attribute to set
         *      val = The new value
         */

        public static void setAttribute ( int attr, int val )
        {
            SDL_GL_SetAttribute(attr, val);
        }

        /**
         * Set the interval at which to swap window buffers
         *
         * Params:
         *      interval = The interval
         */

        public static void setSwapInterval ( int interval )
        {
            SDL_GL_SetSwapInterval(interval);
        }

        /**
         * Swap the buffers of the given window
         *
         * Params:
         *      win = The window to swap buffers in
         */

        public static void swapWindow ( Window win )
        {
            SDL_GL_SwapWindow(win());
        }
    }

    /**
     * Whether or not SDL/SDL GL has been initialized
     */

    private static bool initialized = false;

    private static bool gl_initialized = false;

    /**
     * Initialize SDL, if it hasn't been already
     *
     * Returns:
     *      True if SDL was successfully initialized
     */

    public static bool init ( )
    {
        if ( !initialized )
        {
            DerelictSDL2.load();
            return initialized = SDL_Init(SDL_INIT_VIDEO) == 0;
        }

        return true;
    }

    /**
     * Initialize the SDL OpenGL bindings, if they haven't been already
     *
     * SDL must be initialized first
     *
     * Returns:
     *      True if SDL GL was successfully initialized
     */

    public static bool initGL ( )
    in
    {
        assert(initialized);
    }
    body
    {
        if ( !gl_initialized )
        {
            GL.setAttribute(GL.CONTEXT_MAJOR_VERSION, 3);
            GL.setAttribute(GL.CONTEXT_MINOR_VERSION, 2);
            GL.setAttribute(GL.DOUBLEBUFFER, 1);
            GL.setAttribute(GL.DEPTH_SIZE, 32);
        }

        return true;
    }

    /**
     * Quit SDL
     */

    public static void quit ( )
    {
        SDL_Quit();
    }

    /**
     * Get the SDL error string
     */

    public static string error ( )
    {
        return to!string(SDL_GetError());
    }
}
