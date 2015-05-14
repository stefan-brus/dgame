module main;

import game.DGame;
import game.SDLApp;

int main ( )
{
    enum width = 800, height = 600;
    auto game = new DGame(width, height);
    auto app = new SDLApp("DGame", width, height, game);
    return app.run();
}
