/**
 * OpenGL utilities
 *
 * Wrapper structs and utility functions
 */

module util.GL;

import derelict.opengl3.gl;

/**
 * GL functions namespace struct wrapper
 */

public struct GL
{
    /**
     * OpenGL constants
     */

    public static enum PROJECTION = GL_PROJECTION;
    public static enum COLOR_BUFFER_BIT = GL_COLOR_BUFFER_BIT;
    public static enum QUADS = GL_QUADS;
    public static enum TRIANGLES = GL_TRIANGLES;

    /**
     * Static constructor
     *
     * Initialize Derelict OpenGL bindings
     */

    static this ( )
    {
        DerelictGL.load();
    }

    /**
     * Set the clear color
     *
     * Params:
     *      r = red
     *      g = green
     *      b = blue
     *      a = alpha
     */

    public static void clearColor ( float r, float g, float b, float a )
    {
        glClearColor(r,g,b,a);
    }

    /**
     * Set the matrix mode
     *
     * Params:
     *      mode = The matrix mode
     */

    public static void matrixMode ( int mode )
    {
        glMatrixMode(mode);
    }

    /**
     * Load the identity matrix
     */

    public static void loadIdentity ( )
    {
        glLoadIdentity();
    }

    /**
     * Multiply the current matrix with an orthographic matrix
     *
     * I have no idea what this means
     *
     * Params:
     *      l = left
     *      r = right
     *      b = bottom
     *      t = top
     *      n = near
     *      f = far
     */

    public static void ortho ( double l, double r, double b, double t, double n, double f )
    {
        glOrtho(l,r,b,t,n,f);
    }

    /**
     * Clear the given buffer
     *
     * Params:
     *      buffer = The buffer bit
     */

    public static void clear ( int buffer )
    {
        glClear(buffer);
    }

    /**
     * Begin drawing the given primitive
     *
     * Params:
     *      mode = The primitive to draw
     */

    public static void begin ( int mode )
    {
        glBegin(mode);
    }

    /**
     * Finish drawing a primitive
     */

    public static void end ( )
    {
        glEnd();
    }

    /**
     * Add a vertex at the given (x,y) point
     *
     * Params:
     *      x = The x coordinate
     *      y = The y coordinate
     */

    public static void vertex2f ( float x, float y )
    {
        glVertex2f(x, y);
    }

    /**
     * Set the current color
     *
     * Params:
     *      r = red
     *      g = green
     *      b = blue
     */

    public static void color3ub ( ubyte r, ubyte g, ubyte b )
    {
        glColor3ub(r, g, b);
    }

    /**
     * Translate the current matrix along (x, y)
     *
     * Params:
     *      x = The distance along the x axis
     *      y = The distance along the y axis
     */

    public static void translate2f ( float x, float y )
    {
        glTranslatef(x, y, 0);
    }

    /**
     * Push the current matrix to some kind of stack (presumably)
     */

    public static void pushMatrix ( )
    {
        glPushMatrix();
    }

    /**
     * (Probably) pop the top matrix from the magic matrix stack
     */

    public static void popMatrix ( )
    {
        glPopMatrix();
    }

    /**
     * Flush the GL command buffer (I think)
     */

    public static void flush ( )
    {
        glFlush();
    }
}
