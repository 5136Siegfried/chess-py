import sys
import os

import chess

# Ajoute `src/` au chemin d'import
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from game.board import ChessBoard
from ai.stockfish_ai import ChessAI

def play_cli():
    """Mode 2 joueurs (local)"""
    board = ChessBoard()
    print("Bienvenue dans Chess CLI !\nTapez 'exit' pour quitter.\n")

    while not board.is_game_over():
        print_board(board.board)
        move = input("Entrez votre coup (ex: e2e4) : ")

        if move.lower() == "exit":
            print("Partie interrompue.")
            break

        if not board.move(move):
            print("Coup invalide, essayez encore !")
        print("\n")

    print("Partie terminée !")

def play_vs_ai():
    """Mode joueur vs IA"""
    board = ChessBoard()
    ai = ChessAI()

    # Demander au joueur s'il veut jouer Blanc ou Noir
    color = input("Voulez-vous jouer avec les Blancs (b) ou les Noirs (n) ? ").strip().lower()
    player_is_white = color == "b"

    print("Vous jouez contre l'IA Stockfish ! Tapez 'exit' pour quitter.\n")

    while not board.is_game_over():
        print_board(board.board)

        if (board.board.turn == chess.WHITE and player_is_white) or (board.board.turn == chess.BLACK and not player_is_white):
            move = input("Entrez votre coup (ex: e2e4) : ")

            if move.lower() == "exit":
                print("Partie interrompue.")
                break

            if not board.move(move):
                print("Coup invalide, essayez encore !")
                continue
        else:
            ai_move = ai.get_best_move(board.board.fen())
            board.move(ai_move)
            print(f"L'IA joue : {ai_move}\n")

    print("Partie terminée !")

def print_board(board, player_is_white=True):
    """Affiche l'échiquier avec un quadrillage et les coordonnées correctement orientées."""
    board_str = str(board).split("\n")

    if not player_is_white:
        board_str.reverse()  # On inverse si le joueur est Noir

    print("  a b c d e f g h")
    print("  ---------------")

    for i, row in enumerate(board_str):
        if player_is_white:
            print(f"{8 - i}|{row}|{8 - i}")  # Orientation normale
        else:
            print(f"{i+1}|{row}|{i+1}")  # Orientation inversée si Noirs

    print("  ---------------")
    print("  a b c d e f g h\n")



if __name__ == "__main__":
    print("Choisissez un mode de jeu :")
    print("1. 2 joueurs (local)")
    print("2. Jouer contre l'IA")

    choix = input("Votre choix : ")

    if choix == "1":
        play_cli()
    elif choix == "2":
        play_vs_ai()
    else:
        print("Option invalide. Relancez le script.")
