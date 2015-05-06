module main;

import game.DGame;
import game.SDLApp;

int main ( )
{
    auto game = new DGame;
    auto app = new SDLApp("DGame", 640, 480, game);
    return app.run();
}
