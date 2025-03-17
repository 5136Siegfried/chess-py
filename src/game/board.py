import chess

class ChessBoard:
    def __init__(self):
        self.board = chess.Board()

    def move(self, move_uci):
        """Joue un coup en format UCI (ex: 'e2e4')."""
        if chess.Move.from_uci(move_uci) in self.board.legal_moves:
            self.board.push(chess.Move.from_uci(move_uci))
            return True
        return False

    def is_game_over(self):
        """Retourne True si la partie est finie."""
        return self.board.is_game_over()

    def get_legal_moves(self):
        """Retourne la liste des coups possibles."""
        return [move.uci() for move in self.board.legal_moves]

    def __str__(self):
        return str(self.board)
