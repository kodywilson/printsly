require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'

module CommonStuff

  def prompt
    print ">> "
  end

  def yes_no
    #restrict input to valid answers, but don't worry about case
    begin
      puts "Please enter [yes] or [no]:"
      prompt; @yes_no = STDIN.gets.chomp.downcase
    end while not (@yes_no == "yes" or @yes_no == "no")
  end

  def choose_file
    puts #formatting
    puts "Please enter the full path to the spreadsheet:"
    prompt; gets.chomp
  end

end

include CommonStuff

class Printers
  attr_accessor :store_printers

  def initialize
    puts
    puts "Printsly will help you add printers to CUPS."
    puts
  end

  def build
    begin
      spread = choose_file
      puts #formatting
      puts "You have chosen #{spread}. Is this correct?"
      yes_no
    end while not (@yes_no == "yes")

    book = Spreadsheet.open spread
    sheet1 = book.worksheet 0
    store = sheet1.row(0)[0][6..8]
    printers = Hash.new
    sheet1.each 5 do |row|
      break if row[0].nil?
      printername = row[4]
      if printername != nil
        if printername.include?(store) || printername.include?('RT') || printername.include?('SIM')
          printer = Array.new
          printer = printer.push row[4] # name
          printer = printer.push row[5] # ip address
          printer = printer.push row[3] # Model
          printer = printer.push row[0] # Description
          printers[printername] = printer
        end
      end
    end

    puts
    puts "This is what I am planning on provisioning for store " + store + ":"
    puts

    printers.each do | printername, printerdata |
      puts "lpadmin -p " + printerdata[0] + " -L \"" + printerdata[3] + "\" -D \"" + printerdata[2] + "\" -E -v socket://" + printerdata[1] + ":9100 -m raw"
    end
  end

end
