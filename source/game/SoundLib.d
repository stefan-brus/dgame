/**
 * The game's sound library
 */

module game.SoundLib;

import util.SDL;

import std.exception;

/**
 * Soundlib singleton
 */

public class SoundLib
{
    /**
     * Sound library keys
     */

    public static enum DEAD = "res/dead.wav";
    public static enum HIT = "res/hit.wav";
    public static enum SHOOT = "res/shoot.wav";

    /**
     * Music library keys
     */

    public static enum MUSIC = "res/KoD-VideoGameMetal.mid";

    /**
     * The volume of the music
     */

    private static enum MUSIC_VOLUME = 30;

    /**
     * Singleton instance
     */

    private static SoundLib instance;

    /**
     * Sound map
     */

    private SDL.Mix.Chunk[string] sound_map;

    /**
     * Music map
     */

    private SDL.Mix.Music[string] music_map;

    /**
     * Whether or not music is playing
     */

    private bool music_on;

    /**
     * Constructor, private because singleton
     */

    private this ( )
    {
        this.sound_map[DEAD] = SDL.Mix.loadWAV(DEAD);
        enforce(this.sound_map[DEAD]() !is null);
        this.sound_map[HIT] = SDL.Mix.loadWAV(HIT);
        enforce(this.sound_map[HIT]() !is null);
        this.sound_map[SHOOT] = SDL.Mix.loadWAV(SHOOT);
        enforce(this.sound_map[SHOOT]() !is null);

        this.music_map[MUSIC] = SDL.Mix.loadMUS(MUSIC);
        enforce(this.music_map[MUSIC]() !is null);

        SDL.Mix.volumeMusic(MUSIC_VOLUME);
    }

    /**
     * Destructor
     */

    ~this ( )
    {
        SDL.Mix.freeChunk(this.sound_map[DEAD]);
        SDL.Mix.freeChunk(this.sound_map[HIT]);
        SDL.Mix.freeChunk(this.sound_map[SHOOT]);
    }

    /**
     * Static opCall, get the singleton instance
     *
     * Returns:
     *      The sound lib instance
     */

    public static SoundLib opCall ( )
    {
        if ( instance is null )
        {
            instance = new SoundLib();
        }

        return instance;
    }

    /**
     * Play the given sound
     *
     * Params:
     *      sound = The key of the sound to play
     */

    public void play ( string sound )
    in
    {
        assert(sound in this.sound_map);
    }
    body
    {
        SDL.Mix.playChannel(this.sound_map[sound]);
    }

    /**
     * Start playing the given music
     *
     * Params:
     *      music = The key of the music to play
     */

    public void startMusic ( string music )
    in
    {
        assert(music in this.music_map);
    }
    body
    {
        SDL.Mix.playMusic(this.music_map[music]);
        this.music_on = true;
    }

    /**
     * Toggle whether or not the music is playing
     */

    public void toggleMusic ( )
    {
        if ( this.music_on )
        {
            SDL.Mix.pauseMusic();
            this.music_on = false;
        }
        else
        {
            SDL.Mix.resumeMusic();
            this.music_on = true;
        }
    }
}
