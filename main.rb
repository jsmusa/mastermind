class SecretCode
  attr_reader :code, :possible_codes

  def initialize
    @colors = {
      1 => "red",
      2 => "blue",
      3 => "yellow",
      4 => "green",
      5 => "purple",
      6 => "orange"
    }
  end

  def set_code
    @code = @colors.keys.shuffle.take(4)
  end
end

class Intro
  def instructions

  end
end

class Game
  attr_accessor :quit

  def initialize
    @computer = SecretCode.new
    @computer.set_code
    @quit = false
  end

  def guess_check(guess_code, secret_code)
    @clue = []
    (0..3).each do |i|
      if guess_code[i] == secret_code[i] then @clue.push("O") end
    end
    
    intersection = (guess_code & secret_code).flat_map do |num|
      [num]*[guess_code.count(num), secret_code.count(num)].min
    end
    
    frequency_x = intersection.length - @clue.length
    @clue.push(*["X"] * frequency_x)
  end

  def ask_code(string)
    puts "Input your #{string} as numbers separated by commas (e.g. 1, 2, 3, 4):"
    gets.chomp.gsub(/\s+/,"").split(",").map {|number| number.to_i}
  end

  def restart?
    puts "\nDo you want to play again?\nPress 'y' to play again or 'n' to quit.\n"
    answer = gets.chomp
    puts
    
    if answer == "n" then @quit = true end 
  end

  def breaker_play
    12.times do
      
      guess = ask_code("guess")
      guess_check(guess, @computer.code)
      
      puts "#{guess} Clues: #{@clue}\n\n"

      if (@clue == ["O"] * 4)
        puts "\nYou got the code, you win!"
        return
      end
    end

    puts "\nThe secret code is: #{@computer.code}"
    puts "Game Over! You lose..."
  end

  def setter_play
    possible_codes = []
    [1, 2, 3, 4, 5, 6].repeated_permutation(4) {|permutation| possible_codes.push(permutation)}
    secret_code = ask_code("secret code")
    guess = [1, 1, 2, 2]

    12.times do
      guess_check(guess, secret_code)
      puts "Computer guess: #{guess} Clues: #{@clue}\n\n"
      if (@clue == ["O"] * 4)
        puts "Computer wins!"
        return
      end

      temp = @clue.intersection

      possible_codes.select! do |code|
        guess_check(guess, code)
        @clue == temp
      end

      guess = possible_codes.shuffle.fetch(0)
    end
  end
end

my_game = Game.new

loop do
  puts "Press 1 to play as code breaker or 2 to play as code setter."
  game_mode = gets.chomp.to_i
  puts

  if game_mode == 1 then my_game.breaker_play
  elsif game_mode == 2 then my_game.setter_play
  else
    puts "Invalid input please try again."
  end

  my_game.restart?

  if my_game.quit == true
    return
  end
end