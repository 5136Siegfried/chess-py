from ai.stockfish_ai import ChessAI

ai = ChessAI()
best_move = ai.get_best_move("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
print("Meilleur coup:", best_move)
