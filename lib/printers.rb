class Printers
  attr_accessor :store_printers

  def initialize
    puts
    puts "Let's get started."
    puts
  end

  def build spread

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

    if Dir.exists?("/var/log/cups")
      File.new("/var/log/cups/provision_log", "w+") unless File.exists?("/var/log/cups/provision_log")
    end

    printers.each do | printername, printerdata |
      printerdata[0] = "0" + store + printerdata[0] if printerdata[0].include?('RT')
      printerdata[0] = "0" + store + printerdata[0] if printerdata[0].include?('SIM')
      puts "lpadmin -p " + printerdata[0] + " -L \"" + printerdata[3] + "\" -D \"" + printerdata[2] + "\" -E -v socket://" + printerdata[1] + ":9100 -m raw"
      #puts "Name: ".yellow + printerdata[0] + " " + "Type: ".yellow + printerdata[2] + " " + "IP: ".yellow + printerdata[1] + " " + "Desc: ".yellow + printerdata[3]
      if File.exists?("/var/log/cups/provision_log")
        timey = Time.new
        File.open("/var/log/cups/provision_log", "a") do |f|
          f.puts "Added: " + timey.inspect + " lpadmin -p " + printerdata[0] + " -L \"" + printerdata[3] + "\" -D \"" + printerdata[2] + "\" -E -v socket://" + printerdata[1] + ":9100 -m raw"
        end
      end
    end
  end

end
