module ShowText

  def auto_text
    puts #format
    puts "Auto provision".yellow + " means provisioning is done immediately with no"
    puts "confirmation dialogue."
  end

  def bar_both
    puts # formatting
    puts bar_top.yellow
    puts bar_low.yellow
    puts # formatting
  end

  def bar_low
    "-"*78
  end

  def bar_top
    "_"*34 + " " + "Printsly" + " " + "_"*34
  end

  def batchy_text
    puts #format
    puts "Batch mode".yellow + " means all spreadsheets in the " + "working directory".yellow + " will be processed."
  end

  def lpadmin_puts printerdata
    "lpadmin -p " + printerdata[0] + " -L \"" + printerdata[3] + "\" -D \"" + printerdata[2] + "\" -E -v socket://" + printerdata[1] + ":9100 -m raw"
  end

  def prov_text store
    "This is what I am planning on provisioning for store " + store + ":"
  end

  def printer_puts printerdata
    "Name: ".yellow + printerdata[0] + " " + "Type: ".yellow + printerdata[2] + " " + "IP: ".yellow + printerdata[1] + " " + "Desc: ".yellow + printerdata[3]
  end

  def welcome_text
    puts "If this is the first time to run Printsly, please choose " + "[3]".yellow + " and configure."
    puts #format
    puts "The configuration file is stored in your home directory by default."
  end

  def work_dir_text
    puts #format
    puts "The " + "working directory".yellow + " is the location " + "Printsly".yellow + " will look for"
    puts "spreadsheets containing printers to add to " + "CUPS".yellow + "."
  end

end
