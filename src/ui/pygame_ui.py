import pygame
import chess
import sys
import os

# Ajouter le chemin du projet pour trouver les modules
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from game.board import ChessBoard
from ai.stockfish_ai import ChessAI

# Historique des coups et pièces capturées
move_history = []
captured_white = []
captured_black = []

# Couleurs
WHITE = (238, 238, 210)
BLACK = (118, 150, 86)
HIGHLIGHT_COLOR = (186, 202, 68, 150)
BACKGROUND_COLOR = (200, 200, 200)
LAST_MOVE_COLOR = (255, 255, 0, 150)
CAPTURE_COLOR = (255, 0, 0, 150)


# Dimensions
WIDTH, HEIGHT = 1000, 700  # 🔥 Largeur augmentée pour ne pas tasser les colonnes
BOARD_SIZE = 640  # L’échiquier reste carré
LOG_WIDTH = 180  # 🔥 Ajusté pour l'historique
CAPTURE_WIDTH = 180  # 🔥 Ajusté pour les pièces capturées
SQUARE_SIZE = BOARD_SIZE // 8  # Inchangé


# Initialisation Pygame
pygame.init()
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Jeu d'échecs")

# Chargement des pièces
PIECES_PATH = os.path.join(os.path.dirname(__file__), "../assets/pieces/")
PIECE_NAMES = {
    "r": "bR",
    "n": "bN",
    "b": "bB",
    "q": "bQ",
    "k": "bK",
    "p": "bP",
    "R": "wR",
    "N": "wN",
    "B": "wB",
    "Q": "wQ",
    "K": "wK",
    "P": "wP",
}
PIECE_IMAGES = {
    piece: pygame.transform.scale(
        pygame.image.load(os.path.join(PIECES_PATH, f"{filename}.png")).convert_alpha(),
        (SQUARE_SIZE, SQUARE_SIZE),
    )
    for piece, filename in PIECE_NAMES.items()
    if os.path.exists(os.path.join(PIECES_PATH, f"{filename}.png"))
}

# Initialisation du jeu
board = ChessBoard()
ai = ChessAI()
ai.engine.set_skill_level(3)
ai.engine.set_depth(6)
selected_square = None


def draw_sidebar():
    """Dessine les colonnes des pièces capturées (à gauche) et de l'historique (à droite)."""
    pygame.draw.rect(
        screen, BACKGROUND_COLOR, (0, 0, CAPTURE_WIDTH, HEIGHT)
    )  # 🆕 Colonne capturée à gauche
    pygame.draw.rect(
        screen, BACKGROUND_COLOR, (BOARD_SIZE + CAPTURE_WIDTH, 0, LOG_WIDTH, HEIGHT)
    )  # 🆕 Colonne historique à droite


def draw_board(legal_moves=None):
    """Affiche l'échiquier bien centré et les coups possibles."""
    board_x_offset = CAPTURE_WIDTH  # 🔥 Décalage pour éviter qu'il soit collé à gauche

    for row in range(8):
        for col in range(8):
            color = WHITE if (row + col) % 2 == 0 else BLACK
            pygame.draw.rect(
                screen,
                color,
                (
                    board_x_offset + col * SQUARE_SIZE,
                    row * SQUARE_SIZE,
                    SQUARE_SIZE,
                    SQUARE_SIZE,
                ),
            )

    # 🔥 Correction : affichage des mouvements possibles
    if legal_moves:
        for move in legal_moves:
            end_square = chess.parse_square(move[2:4])
            x, y = chess.square_file(end_square), 7 - chess.square_rank(end_square)

            highlight_surface = pygame.Surface(
                (SQUARE_SIZE, SQUARE_SIZE), pygame.SRCALPHA
            )
            highlight_surface.fill(HIGHLIGHT_COLOR)
            screen.blit(
                highlight_surface, (board_x_offset + x * SQUARE_SIZE, y * SQUARE_SIZE)
            )


def draw_pieces():
    """Affiche les pièces correctement positionnées sur l'échiquier."""
    board_x_offset = CAPTURE_WIDTH  # 🔥 Décalage pour aligner avec `draw_board()`
    for square in chess.SQUARES:
        piece = board.board.piece_at(square)
        if piece:
            x, y = chess.square_file(square), 7 - chess.square_rank(square)
            screen.blit(
                PIECE_IMAGES[piece.symbol()],
                (board_x_offset + x * SQUARE_SIZE, y * SQUARE_SIZE),
            )


def draw_move_log():
    """Affiche l'historique des coups dans la colonne de droite."""
    font = pygame.font.Font(None, 24)
    log_x = CAPTURE_WIDTH + BOARD_SIZE + 20  # 🔥 Décalé correctement
    log_y = 20

    screen.fill(
        BACKGROUND_COLOR, (CAPTURE_WIDTH + BOARD_SIZE, 0, LOG_WIDTH, HEIGHT)
    )  # 🔥 Nettoie la colonne avant d'afficher

    text_surface = font.render("📜 Coups", True, (0, 0, 0))
    screen.blit(text_surface, (log_x, log_y))
    log_y += 30

    for i, move in enumerate(move_history):
        move_text = f"{(i // 2) + 1}. {move}"
        text_surface = font.render(move_text, True, (0, 0, 0))
        screen.blit(text_surface, (log_x, log_y))
        log_y += 20


def draw_resign_button():
    """Affiche le bouton abandon centré sous l'échiquier."""
    button_x = CAPTURE_WIDTH + (BOARD_SIZE // 2) - 75  # 🔥 Centré sous l’échiquier
    button_y = 660  # 🔥 Bien en bas
    button_w, button_h = 150, 40
    pygame.draw.rect(screen, (200, 50, 50), (button_x, button_y, button_w, button_h))
    font = pygame.font.Font(None, 26)
    screen.blit(
        font.render("⚠ Abandonner", True, (255, 255, 255)),
        (button_x + 20, button_y + 10),
    )


def draw_captured_pieces():
    """Affiche les icônes des pièces capturées dans la colonne de gauche."""
    x_start, y_white, y_black = 10, 100, 500

    font = pygame.font.Font(None, 24)
    screen.blit(font.render("♟️ Blancs", True, (0, 0, 0)), (x_start, y_white - 20))
    screen.blit(font.render("♟️ Noirs", True, (0, 0, 0)), (x_start, y_black - 20))

    for i, piece in enumerate(captured_white):
        screen.blit(
            PIECE_IMAGES[piece], (x_start + (i % 4) * 30, y_white + (i // 4) * 30)
        )

    for i, piece in enumerate(captured_black):
        screen.blit(
            PIECE_IMAGES[piece], (x_start + (i % 4) * 30, y_black + (i // 4) * 30)
        )


def get_square_from_pos(pos):
    """Convertit une position de clic en coordonnées d'échiquier."""
    x, y = pos
    col = (x - CAPTURE_WIDTH) // SQUARE_SIZE  # 🔥 On enlève le décalage
    row = 7 - (y // SQUARE_SIZE)
    return chess.square(col, row)


def capture_piece(move):
    """Ajoute une pièce capturée avec son icône dans la liste des pièces capturées."""
    piece = board.board.piece_at(move.to_square)
    if piece:
        piece_symbol = piece.symbol()
        if piece.color == chess.WHITE:
            captured_white.append(piece_symbol)
        else:
            captured_black.append(piece_symbol)

def main():
    global selected_square
    running = True
    legal_moves = []

    while running:
        draw_board(legal_moves)
        draw_pieces()
        draw_sidebar()
        draw_move_log()
        draw_captured_pieces()
        draw_resign_button()
        pygame.display.flip()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

            if event.type == pygame.MOUSEBUTTONDOWN:
                x, y = pygame.mouse.get_pos()
                square = get_square_from_pos((x, y))

                # 🔥 Vérifier si on clique sur le bouton "Abandonner"
                if 650 <= x <= 790 and 660 <= y <= 700:
                    print("🚩 Partie abandonnée !")
                    running = False
                    break  # 🔥 Sort de la boucle immédiatement

                # 🔥 Vérifier d'abord si on clique sur l'échiquier
                if 0 <= square < 64:  # Assure que c'est une case valide
                    if selected_square is None:
                        piece = board.board.piece_at(square)
                        if piece and piece.color == board.board.turn:
                            selected_square = square
                            legal_moves = [
                                move.uci()
                                for move in board.board.legal_moves
                                if move.from_square == square
                            ]
                    else:
                        move = chess.Move(selected_square, square)
                        if move in board.board.legal_moves:
                            capture_piece(move)
                            move_history.append(move.uci())
                            board.move(move.uci())

                            print(f"♟️ Joueur joue : {move.uci()}")

                            if not board.is_game_over():
                                ai_move = ai.get_best_move(board.board.fen())
                                ai_move_obj = chess.Move.from_uci(ai_move)
                                capture_piece(ai_move_obj)
                                move_history.append(ai_move)
                                board.move(ai_move)
                                print(f"🤖 L'IA joue : {ai_move}")

                        selected_square = None
                        legal_moves = []

            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_r and len(move_history) >= 2:
                    board.board.pop()
                    move_history.pop()
                    board.board.pop()
                    move_history.pop()
                    print("↩ Coup annulé !")

    pygame.quit()
    sys.exit()

if __name__ == "__main__":
    main()
