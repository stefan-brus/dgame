import derelict.sdl2.sdl;

void main()
{
    DerelictSDL2.load();
    SDL_Init(SDL_INIT_VIDEO);
    auto win = SDL_CreateWindow("DGame", 100, 100, 640, 480, SDL_WINDOW_SHOWN);
    assert(win !is null);
    auto surface = SDL_GetWindowSurface(win);
    assert(surface !is null);
    SDL_FillRect(surface, null, SDL_MapRGB(surface.format, 0xff, 0xff, 0xff));
    SDL_UpdateWindowSurface(win);
    SDL_Delay(2000);
    SDL_DestroyWindow(win);
    SDL_Quit();
}
