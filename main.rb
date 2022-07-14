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

class Game
  def initialize
    @computer = SecretCode.new
    @computer.set_code
  end

  def guess_check(guess_code, secret_code)
    @clue = []
    (0..3).each do |i|
      if guess_code[i] == secret_code[i] then @clue.push("O") end
    end
    
    frequency_x = guess_code.intersection(secret_code).length - @clue.length
    @clue.push(*["X"] * frequency_x)
  end

  def ask_code(string)
    puts "Input your #{string} as numbers separated by commas (e.g. 1, 2, 3, 4):"
    gets.chomp.gsub(/\s+/,"").split(",").map {|number| number.to_i}
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
    [1, 2, 3, 4, 5, 6].permutation(4) {|permutation| possible_codes.push(permutation)}
    secret_code = ask_code("secret code")
    guess = [1, 1, 2, 2]

    12.times do
      guess_check(guess, secret_code)
      puts "Computer guess: #{guess} Clues: #{@clue}\n\n"
      if (@clue == ["O"] * 4)
        puts "Computer wins!"
        return
      end

      temp = @clue.map {|one| one}

      possible_codes.select! do |code|
        guess_check(guess, code)
        @clue == temp
      end

      guess = possible_codes.shuffle.fetch(0)
    end
  end
end

my_game = Game.new
my_game.setter_play

# initial guess 1111 move to 2222 or 3333 until there's one "0" in clue
# replace 3 of the ones with the next number, then replace 2 of the next number 
# with the next next number