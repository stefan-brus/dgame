/**
 * SDL Utilities
 *
 * Wrapper structs and utility functions
 */

module util.SDL;

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

            result(SDL_CreateWindow(toStringz(name), 100, 100, width, height, SDL_WINDOW_SHOWN));

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
         * SDL_Quit constant
         */

        public static const QUIT = SDL_QUIT;

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
     * Whether or not SDL has been initialized
     */

    private static bool initialized = false;

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
