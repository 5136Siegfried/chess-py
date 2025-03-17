import pygame
import chess


import sys
import os

# Ajoute `src/` au chemin d'import pour que Python trouve `game`
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from game.board import ChessBoard
from ai.stockfish_ai import ChessAI

# Définition des couleurs
WHITE = (238, 238, 210)
BLACK = (118, 150, 86)
HIGHLIGHT = (186, 202, 68)

# Taille de la fenêtre et des cases
WIDTH, HEIGHT = 640, 640
SQUARE_SIZE = WIDTH // 8

# Initialiser Pygame
pygame.init()
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Jeu d'échecs")

# Définition du chemin des images
PIECES_PATH = os.path.join(os.path.dirname(__file__), "../assets/pieces/")

# Mapping des pièces entre python-chess et les noms d'images
PIECE_NAMES = {
    "r": "bR", "n": "bN", "b": "bB", "q": "bQ", "k": "bK", "p": "bP",
    "R": "wR", "N": "wN", "B": "wB", "Q": "wQ", "K": "wK", "P": "wP"
}

# Charger les images des pièces avec la transparence
PIECE_IMAGES = {}
for piece, filename in PIECE_NAMES.items():
    image_path = os.path.join(PIECES_PATH, f"{filename}.png")
    if os.path.exists(image_path):
        image = pygame.image.load(image_path).convert_alpha()  # Active la transparence
        PIECE_IMAGES[piece] = pygame.transform.scale(image, (SQUARE_SIZE, SQUARE_SIZE))
    else:
        print(f"⚠️ Image manquante : {image_path}")
# Initialiser le jeu et l'IA
board = ChessBoard()
ai = ChessAI()
selected_square = None

def draw_board():
    """Affiche l'échiquier."""
    for row in range(8):
        for col in range(8):
            color = WHITE if (row + col) % 2 == 0 else BLACK
            pygame.draw.rect(screen, color, (col * SQUARE_SIZE, row * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE))

def draw_pieces():
    """Affiche les pièces correctement placées sur l'échiquier."""
    for square in chess.SQUARES:
        piece = board.board.piece_at(square)
        if piece:
            piece_str = piece.symbol()  # Récupère le symbole de la pièce (ex: 'P', 'n')
            x, y = chess.square_file(square), 7 - chess.square_rank(square)  # Position correcte
            screen.blit(PIECE_IMAGES[piece_str], (x * SQUARE_SIZE, y * SQUARE_SIZE))


def get_square_from_pos(pos):
    """Convertit une position de clic en coordonnées d'échiquier."""
    x, y = pos
    col = x // SQUARE_SIZE
    row = y // SQUARE_SIZE
    return chess.square(col, 7 - row)  # Inversion pour s'aligner sur l'affichage de chess.Board()

def main():
    global selected_square
    running = True

    while running:
        draw_board()
        draw_pieces()
        pygame.display.flip()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

            if event.type == pygame.MOUSEBUTTONDOWN:
                square = get_square_from_pos(pygame.mouse.get_pos())

                if selected_square is None:  # Sélection d'une pièce
                    if board.board.piece_at(square):
                        selected_square = square
                else:  # Tentative de déplacement
                    move = chess.Move(selected_square, square)
                    if move in board.board.legal_moves:
                        board.move(move.uci())

                        if not board.is_game_over():
                            ai_move = ai.get_best_move(board.board.fen())
                            board.move(ai_move)

                    selected_square = None  # Réinitialiser la sélection

    pygame.quit()

if __name__ == "__main__":
    main()
