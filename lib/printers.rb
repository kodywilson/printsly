class Printers
  #attr_accessor :store_printers

  def batch spread
    book = Spreadsheet.open spread
    sheet1 = book.worksheet 0
    store = sheet1.row(0)[0][6..8]
    printers = hashy(sheet1, store)
    provision(printers, store)
    printers
  end

  def initialize

  end

  def hashy sheet, store
    store_printers = Hash.new
    sheet.each 5 do |row|
      break if row[0].nil?
      printername = row[4]
      if printername != nil
        store_printers[printername] = printer(row, printername, store)
      end
    end
    store_printers
  end

  def show_printers printers, store
    puts
    puts prov_text(store)
    puts
    printers.each do | printername, printerdata |
      printerdata[0] = mod_name(printerdata[0], store)
      puts printer_puts(printerdata)
    end
  end

  def printer row, printername, store
    if printername.include?(store) || printername.include?('RT') || printername.include?('SIM')
      printer = Array.new
      printer = printer.push row[4] # name
      printer = printer.push row[5] # ip address
      printer = printer.push row[3] # Model
      printer = printer.push row[0] # Description
      printer
    end
  end

  def provision printers, store
    log_file
    printers.each do | printername, printerdata |
      printerdata[0] = mod_name(printerdata[0], store)
      puts lpadmin_puts(printerdata)
      log_entry(printerdata)
    end
  end

end
