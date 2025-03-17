import os

from stockfish import Stockfish

class ChessAI:
    def __init__(self):
        stockfish_path = os.getenv("STOCKFISH_PATH", "/opt/homebrew/bin/stockfish")  # Chemin Linux
        self.engine = Stockfish(stockfish_path)

    def get_best_move(self, fen):
        """Prend un état de jeu (FEN) et retourne le meilleur coup."""
        self.engine.set_fen_position(fen)
        return self.engine.get_best_move()
        self.engine.set_skill_level(3)  # Réduit la force de l'IA (0 = facile, 20 = difficile)
        self.engine.set_depth(6)  # Réduit la profondeur de calcul (8 est moyen, 20 est élite)
