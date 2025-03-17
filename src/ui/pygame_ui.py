import pygame
import chess
import sys
import os

# Ajouter le chemin du projet pour trouver les modules
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from game.board import ChessBoard
from ai.stockfish_ai import ChessAI

# Historique des coups pour le mode rembobiner
move_history = []

# Définition des couleurs
WHITE = (238, 238, 210)
BLACK = (118, 150, 86)
HIGHLIGHT_COLOR = (186, 202, 68, 150)  # Couleur pour les coups possibles

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

# Charger les images des pièces
PIECE_IMAGES = {}
for piece, filename in PIECE_NAMES.items():
    image_path = os.path.join(PIECES_PATH, f"{filename}.png")
    if os.path.exists(image_path):
        image = pygame.image.load(image_path).convert_alpha()
        PIECE_IMAGES[piece] = pygame.transform.scale(image, (SQUARE_SIZE, SQUARE_SIZE))
    else:
        print(f"⚠️ Image manquante : {image_path}")

# Initialiser le jeu et l'IA
board = ChessBoard()
ai = ChessAI()

# Rendre l’IA plus facile
ai.engine.set_skill_level(3)  # (0 = ultra facile, 20 = élite)
ai.engine.set_depth(6)  # Profondeur de réflexion

selected_square = None

def draw_move_log():
    """Affiche l'historique des coups à droite de l'échiquier."""
    font = pygame.font.Font(None, 24)
    log_x = 650  # Position X pour afficher les coups
    log_y = 20  # Position Y de départ

    pygame.draw.rect(screen, (50, 50, 50), (640, 0, LOG_WIDTH, HEIGHT))  # Fond gris foncé

    text_surface = font.render("📜 Historique des coups", True, (255, 255, 255))
    screen.blit(text_surface, (log_x, log_y))
    log_y += 30

    for i, move in enumerate(move_history):
        move_text = f"{(i // 2) + 1}. {move}" if i % 2 == 0 else move
        text_surface = font.render(move_text, True, (255, 255, 255))
        screen.blit(text_surface, (log_x, log_y))
        log_y += 20  # Espacement entre les coups


def draw_board(legal_moves=None):
    """Affiche l'échiquier avec les cases surlignées si nécessaire."""
    for row in range(8):
        for col in range(8):
            color = WHITE if (row + col) % 2 == 0 else BLACK
            pygame.draw.rect(screen, color, (col * SQUARE_SIZE, row * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE))

    if legal_moves:
        for move in legal_moves:
            end_square = chess.parse_square(move[2:4])
            x, y = chess.square_file(end_square), 7 - chess.square_rank(end_square)

            highlight_surface = pygame.Surface((SQUARE_SIZE, SQUARE_SIZE), pygame.SRCALPHA)
            highlight_surface.fill(HIGHLIGHT_COLOR)
            screen.blit(highlight_surface, (x * SQUARE_SIZE, y * SQUARE_SIZE))

def draw_pieces():
    """Affiche les pièces correctement placées sur l'échiquier."""
    for square in chess.SQUARES:
        piece = board.board.piece_at(square)
        if piece:
            piece_str = piece.symbol()
            x, y = chess.square_file(square), 7 - chess.square_rank(square)
            screen.blit(PIECE_IMAGES[piece_str], (x * SQUARE_SIZE, y * SQUARE_SIZE))

def animate_move(piece, start_pos, end_pos):
    """Anime le déplacement d'une pièce."""
    frames = 10
    x1, y1 = start_pos
    x2, y2 = end_pos
    dx, dy = (x2 - x1) / frames, (y2 - y1) / frames

    for i in range(frames):
        screen.fill((0, 0, 0))
        draw_board()
        draw_pieces()
        screen.blit(PIECE_IMAGES[piece], (x1 + i * dx, y1 + i * dy))
        pygame.display.flip()
        pygame.time.delay(20)

def promote_pawn(move):
    """Gère la promotion automatique d'un pion en dame."""
    move_obj = move if isinstance(move, chess.Move) else chess.Move.from_uci(move)
    piece = board.board.piece_at(move_obj.to_square)

    if piece and piece.piece_type == chess.PAWN and chess.square_rank(move_obj.to_square) in [0, 7]:
        move_obj.promotion = chess.QUEEN
        print("👑 Promotion en dame !")

def get_square_from_pos(pos):
    """Convertit une position de clic en coordonnées d'échiquier."""
    x, y = pos
    col, row = x // SQUARE_SIZE, y // SQUARE_SIZE
    return chess.square(col, 7 - row)

def main():
    global selected_square
    running = True
    legal_moves = []

    while running:
      draw_board(legal_moves)
      draw_pieces()
      draw_move_log()  # 🔥 Affiche l’historique des coups
      pygame.display.flip()


      for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_r and len(move_history) >= 2:
                    board.board.pop()  # Annule le dernier coup (IA)
                    move_history.pop()
                    board.board.pop()  # Annule le coup du joueur
                    move_history.pop()
                    print("↩ Coup annulé !")

            if event.type == pygame.MOUSEBUTTONDOWN:
                square = get_square_from_pos(pygame.mouse.get_pos())

                if selected_square is None:
                    piece = board.board.piece_at(square)
                    if piece and (piece.color == board.board.turn):
                        selected_square = square
                        legal_moves = [move.uci() for move in board.board.legal_moves if move.from_square == square]
                else:
                    move = chess.Move(selected_square, square)

                    if move in board.board.legal_moves:
                        move_history.append(move.uci())  # Sauvegarde du coup
                        promote_pawn(move)
                        board.move(move.uci())

                        if board.board.is_castling(move):
                            print("♜ Roque effectué !")

                        # Tour de l'IA
                        if not board.is_game_over():
                            ai_move = ai.get_best_move(board.board.fen())
                            move_history.append(ai_move)  # Sauvegarde du coup IA
                            promote_pawn(ai_move)
                            board.move(ai_move)

                    selected_square = None
                    legal_moves = []

    pygame.quit()

if __name__ == "__main__":
    main()
