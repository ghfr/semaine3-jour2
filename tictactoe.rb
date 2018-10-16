require 'colorize'

class BoardCase
  attr_accessor :valeur
  #definit les valeurs (x,O,nil) dans cases

  def initialize
    @valeur = ' '
  end

  def to_s
    return @valeur  # Va afficher la valeur en string https://stackoverflow.com/questions/8209194/what-is-the-meaning-of-i-to-s-in-ruby
  end

  def validity(nombre)
    if !((0..9).include?(nombre)) #Definit les numéros entre 0 et 9
      return false
    end

    if @valeur != ' ' #Si vide
      return false
    end
    return true
  end
end
class Board
  attr_accessor :boardcases
  #faire le lien entre BoardCase et le Game =
  #definit plateau en lien avec les cases

  def colorize(text, color = "default", bgColor = "default") # Code
      colors = {"default" => "38","black" => "30","red" => "31","green" => "32","brown" => "33", "blue" => "34", "purple" => "35",
       "cyan" => "36", "gray" => "37", "dark gray" => "1;30", "light red" => "1;31", "light green" => "1;32", "yellow" => "1;33",
        "light blue" => "1;34", "light purple" => "1;35", "light cyan" => "1;36", "white" => "1;37"}
      bgColors = {"default" => "0", "black" => "40", "red" => "41", "green" => "42", "brown" => "43", "blue" => "44",
       "purple" => "45", "cyan" => "46", "gray" => "47", "dark gray" => "100", "light red" => "101", "light green" => "102",
       "yellow" => "103", "light blue" => "104", "light purple" => "105", "light cyan" => "106", "white" => "107"}
      color_code = colors[color]
      bgColor_code = bgColors[bgColor]
      return "\033[#{bgColor_code};#{color_code}m#{text}\033[0m"
  end

  def initialize
    @boardcases = []
    9.times do #Joueur 9 parties -> On fait 9 cases
      @boardcases.push(BoardCase.new)
    end
  end

  def to_s  #pour afficher en string
    return @boardcases.to_s
  end

  def play(player)#va renvoyer la valeur du joueur
     nombre = 1
   loop do
     puts "C'est à #{player.name} de jouer ".colorize(:black).on_yellow.underline #Premiere Methode pour la couleur
     puts "#{colorize('Voici la disposition des cases pour jouer à notre super Tic Tac Toe !
     A toi de saisir un chiffre maintenant :) : ', "purple")}" # Deuxieme methode (un peu plus compliqué)
     puts  "#{colorize(  "             1 | 2 | 3
            ---|---|---
             4 | 5 | 6
            ---|---|---
             7 | 8 | 9  ", "green")}"
     nombre = gets.chomp.to_i - 1
     redo unless (0..9).include? nombre # Si jamais supérieur à 9
     break if @boardcases[nombre].validity(nombre) # Renvois si superieur à 9 -> Arrête la boucle si le nombre est compris entre 0 et 9
   end

   @boardcases[nombre].valeur = player.valeur
 end
#definir le gagnant
def victory
  gagne_si_ligne || gagne_si_colonne || gagne_si_diagonal
end
def gagne_si_ligne # Methode pour créer une variable de victoire si 3 "X ou 0" en ligne alors = victoire
  gagne_si_ligne = [[0,1,2],[3,4,5],[6,7,8]] #Case on commence du 0
  gagne_si_ligne.each do |line|
    line_str = '' #pour espace
    line.each { |x| line_str << @boardcases[x].to_s }
    return true if ['XXX', 'OOO'].include? line_str # Si 3 symboles se suivent fait gagner en ligne
  end
  false
end

def gagne_si_colonne #Methode pour créer une variable de victoire si 3 "X ou O" en colonne alors victoire
  gagne_si_colonne = [[0,3,6],[1,4,7],[2,5,8]]
  gagne_si_colonne.each do |column|
    column_str = ''
    column.each { |x| column_str << @boardcases[x].to_s }
    return true if ['XXX', 'OOO'].include? column_str # Si 3 symboles se suivent fait gagner en colonne
  end
  false
end

def gagne_si_diagonal # Methode pour créer une variable victoire si 3 "X ou 0" en diagonal alors victoire
  gagne_si_diagonal = [[0,4,8],[2,4,6]] #
  gagne_si_diagonal.each do |diagonal|
    diagonal_str = ''
    diagonal.each { |x| diagonal_str << @boardcases[x].to_s }
    return true if ['XXX', 'OOO'].include? diagonal_str # Si 3 symboles se suivent fait gagner en diagonal
  end
  false
end

def print_board
  puts " #{@boardcases[0]} | #{boardcases[1]} | #{boardcases[2]} "
  puts "---|---|---"
  puts " #{boardcases[3]} | #{boardcases[4]} | #{boardcases[5]} "
  puts "---|---|---"
  puts " #{boardcases[6]} | #{boardcases[7]} | #{boardcases[8]} "
end # Ci dessus pour l'alignement des barres et la grille du morpion

def est_pleine #Va vérifier si le jeu a été rempli si autre chose que espace retourne faslse
  @boardcases.each do |boardcase|
    return false if boardcase.to_s == ' '
  end
  true
end
end
class Player
  # definit les players
  attr_reader :valeur, :name

  def colorize(text, color = "default", bgColor = "default")
      colors = {"default" => "38","black" => "30","red" => "31","green" => "32","brown" => "33", "blue" => "34", "purple" => "35",
       "cyan" => "36", "gray" => "37", "dark gray" => "1;30", "light red" => "1;31", "light green" => "1;32", "yellow" => "1;33",
        "light blue" => "1;34", "light purple" => "1;35", "light cyan" => "1;36", "white" => "1;37"}
      bgColors = {"default" => "0", "black" => "40", "red" => "41", "green" => "42", "brown" => "43", "blue" => "44",
       "purple" => "45", "cyan" => "46", "gray" => "47", "dark gray" => "100", "light red" => "101", "light green" => "102",
       "yellow" => "103", "light blue" => "104", "light purple" => "105", "light cyan" => "106", "white" => "107"}
      color_code = colors[color]
      bgColor_code = bgColors[bgColor]
      return "\033[#{bgColor_code};#{color_code}m#{text}\033[0m"
  end


  def initialize(valeur)
    puts "Bonjour, quel est ton nom s'il te plait ?".colorize(:cyan) #Code couleur
    @name = gets.chomp #Prend le nom du joueur
    @valeur = valeur # prend valeur
  end

end

class Game
  attr_accessor :player1, :player2, :board #Appelle joueur et jeu

  def colorize(text, color = "default", bgColor = "default") #Code couleur
      colors = {"default" => "38","black" => "30","red" => "31","green" => "32","brown" => "33", "blue" => "34", "purple" => "35",
       "cyan" => "36", "gray" => "37", "dark gray" => "1;30", "light red" => "1;31", "light green" => "1;32", "yellow" => "1;33",
        "light blue" => "1;34", "light purple" => "1;35", "light cyan" => "1;36", "white" => "1;37"}
      bgColors = {"default" => "0", "black" => "40", "red" => "41", "green" => "42", "brown" => "43", "blue" => "44",
       "purple" => "45", "cyan" => "46", "gray" => "47", "dark gray" => "100", "light red" => "101", "light green" => "102",
       "yellow" => "103", "light blue" => "104", "light purple" => "105", "light cyan" => "106", "white" => "107"}
      color_code = colors[color]
      bgColor_code = bgColors[bgColor]
      return "\033[#{bgColor_code};#{color_code}m#{text}\033[0m"
  end

  def initialize #Definit X pour joueur 1 et 0 pour joueur 2
    @player1 = Player.new('X')
    @player2 = Player.new('O')
    @board = Board.new
  end


  def start_game
    player = @player2 #On definis player sur player 2 pour changer player en player1 avec la condition qui suit
    loop do
      @board.print_board #Affiche jeu
      if player == @player1 #Si le joueur en cours est le joueur 1, alors on veut que ce soit au tour du joueur 2 de jouer
        player = @player2
      else
        player = @player1
      end
      @board.play(player)
      break if @board.victory || @board.est_pleine
    end
    if @board.victory
      puts "#{player.name} a gagné ! Bravo !!! ".colorize(:red)
      @board.print_board
    elsif @board.est_pleine
      puts "Egalité !"
    end
  end

#Ci dessous tentative pour faire rejouer une partie mais ne fonctionne pas
  # def continue?
    # puts "Veux-tu rejouer ? (O/N)".center(35)
  #   continue = gets.chomp
    # while continue != 'O' && continue != 'N'
    #   continue = gets.chomp
  #   end
  #   if continue == 'O'
    #   print_board(@board)
    #   play
    # else
    # if continue == 'N'
    #   exit
  #   end
#   end

end

game = Game.new.start_game
