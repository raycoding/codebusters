#TradeMetal Class is Data Structure which stores the TradeMetal Name and its Unit Price
class TradeMetal
	attr_accessor :coin_name, :unit_price
	@@metals = []
	def initialize(coin_name, unit_price)
		@coin_name = coin_name
		@unit_price = unit_price
		@@metals << self
	end
	def self.get_trade_metal(question)
		literals = question.split
		@@metals.detect {|trademetal| literals.include? trademetal.coin_name}
	end
end

class Translation
	attr_accessor :pattern
	# This Data Structure stores all assignments of galactic words to their Roman Symbol
	#e.f glob => I, prok => V
	@@galactic_words_roman_symbol_assignments = {}
	def self.galactic_words_roman_symbol_assignments
		@@galactic_words_roman_symbol_assignments
	end

	#Constraints of Substrations
	#"I" can be subtracted from "V" and "X" only. 
	#"X" can be subtracted from "L" and "C" only.
	#"C" can be subtracted from "D" and "M" only.
	#"V", "L", and "D" can never be subtracted.
	#Only one small-value symbol may be subtracted from any large-value symbol.
	@@valid_substractions_in_order = [ #Constructing patterns High to Low
		["M",1000],
		["CM",900],
		["D",500],
		["CD",400],
		["C",100],
		["XC",90],
		["L",50],
		["XL",40],
		["X",10],
		["IX",9],
		["V",5],
		["IV",4],
		["I",1]
	]

	def initialize(pattern)
		@pattern = pattern
	end

	def to_s
		@pattern
	end

	# In main part of the question get all galactic words e.g from glob prok Silver ? it would return glob prok
	def self.translate_question(question)
		galactic_words = []
		question.split.each do |literal|
			@@galactic_words_roman_symbol_assignments.keys.include?(literal) ? (galactic_words << literal ) : (break if galactic_words.size > 0)
		end
		if galactic_words.size > 0
			str = Translation.new(galactic_words.join(' '))
			return (str.is_valid? ? str : nil)
		end
		return nil
	end

	#Given Roman String it can convert to Numeral
	def roman_symbols_to_numeral(roman_string)
		sum = 0
		for key, value in @@valid_substractions_in_order
			while roman_string.index(key)==0
				sum += value
				roman_string.slice!(key)
			end
		end
		sum
	end
	#Given Galactic Words it can convert to Roman
	def galactic_words_to_roman # returns roman representaion 
		@pattern.split.map{ |e|  @@galactic_words_roman_symbol_assignments[e] }.join
	end
	#Given a Galactic words it can convert to Numeral
	#Algo is to convert galactic words to roman first and then from roman symbols to numeral finally
	def galactic_words_to_numeral
		roman_symbols_to_numeral(galactic_words_to_roman)
	end

	def valid_pattern?
		!(galactic_words_to_roman.match(/^M*(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$/).nil?)
	end

	def is_valid?
		invalid_literals = @pattern.split.detect { |e|  !@@galactic_words_roman_symbol_assignments.keys.include? e }
		!invalid_literals && valid_pattern?
	end
end

class MerchantGuideToGalaxy
	attr_accessor :line,:literals

	def initialize(line)
		return if line.chomp == ""
		@line = line
		@literals = line.split
	end

  #Where the line cannot be parsed to any meaningful categories such as Assignment,Credit Statement or Question it is meaningless line
	def throw_away_meaningless_line
		puts "I have no idea what you are talking about"
	end

	def compute_line
		#Check for whether line is an Assignement Line or TradeMetal Credit Lines or Questions. Anything else is meaningless
		if @literals.size == 3 && @literals[1] == "is" #e.g Assignment - glob is I
			process_assignment(@literals[0], @literals[2])
		elsif @literals.last == "Credits" #e.g Credit Statement - glob prok Gold is 57800 Credits
			process_credit_statement
		elsif @literals.include?("how") and @literals.last == "?" #e.g Question - how much is pish tegj glob glob ?
			process_question
		else
			throw_away_meaningless_line
		end
	end

	#Processor for Assignment Lines
	#This Assigns the galatic word used to represent the Roman Symbol like glob = I
	def process_assignment(galactic_word,roman_symbol)
		Translation::galactic_words_roman_symbol_assignments[galactic_word] = roman_symbol #e.g {"glob"=>"I"}
	end

	#Processor for Credit Statement Lines
	#E.g this method finds out the Unit proce of the Trade Metal from Credit Statement
	#E.g glob glob Silver is 34 Credits means I I Silver is 34 Credits means 2 Silver is 34 Credits
	#Therefore if Trade Metal Silver Coin has a Unit Price of 17
	def process_credit_statement
		credit_price_of_metal_coins = 0
		galactic_units = []
		coin_name = ""
		@literals.each do |literal|
			if Translation::galactic_words_roman_symbol_assignments.keys.include?(literal) #returns is the literal passed is a valid galactic word e.g glob is valid, prok is valid
				galactic_units << literal 
			elsif ["is", "Credits"].include? literal # Ignore these words, we don't really care of these words in Credit Statement Lines
				next
			elsif literal.to_i > 0 #This is the trade metal coins credit value .eg 2 Silver is '34' 
				credit_price_of_metal_coins = literal.to_i #e.g 34
			else
				coin_name = literal #.e.g Silver, Gold, Iron
			end
		end
		if !coin_name.empty? && credit_price_of_metal_coins > 0 && galactic_units.size > 0
			units_of_coin_in_galactic_words = Translation.new(galactic_units.join(' ')) #.e.g glob glob 
			units_of_coin_in_numeral = units_of_coin_in_galactic_words.galactic_words_to_numeral #e.g glob glob gets converted to 2
			if units_of_coin_in_numeral > 0
				unit_price =  credit_price_of_metal_coins.to_f/units_of_coin_in_numeral #e.g 2 Silver is 34 so Unit Price is 32/2
				TradeMetal.new(coin_name,unit_price)
			else
				throw_away_meaningless_line
			end
		else
			throw_away_meaningless_line
		end
	end

	#Processor for Question Lines
	def process_question
		#There are two types of Questions - One which starts with 'how many Credits is ' and the other is 'how much is' 
		if @line.start_with? "how many Credits is "
			main_question_part = @line.split("how many Credits is ")[1] #e.g from how many Credits is glob prok Silver ? gets glob prok Silver ?
			galatic_literals = Translation.translate_question(main_question_part) #e.g from glob prok Silver gets glob prok
			trademetal = TradeMetal.get_trade_metal(main_question_part) #e.g from glob prok Silver gets Silver
			if trademetal && galatic_literals
				trademetal_price_credit = (galatic_literals.galactic_words_to_numeral * trademetal.unit_price).to_i
				puts "#{galatic_literals} #{trademetal.coin_name} is #{trademetal_price_credit} Credits"
				return
			end
		elsif @line.start_with? "how much is "
			main_question_part = @line.split("how much is ")[1] #e.g from how much is pish tegj glob glob ? gets pish tegj glob glob ?
			galatic_literals = Translation.translate_question(main_question_part) #e.g from pish tegj glob glob ? gets pish tegj glob glob
			if galatic_literals
				conversion_value = galatic_literals.galactic_words_to_numeral
				puts "#{galatic_literals} is #{conversion_value}"
				return
			end
		end
		throw_away_meaningless_line
	end
end


# Entry Point for the Program
# ---------------------------

def process_input_file file_name
	File.open(file_name, "r").each_line do |line|
		obj=MerchantGuideToGalaxy.new(line)
		obj.compute_line
	end
end

if ARGV.size == 0
	puts "Please pass input file location as argument"
	exit 1
else
	process_input_file ARGV[0]
end