require 'printsly'

book = Spreadsheet.open "lib/test_data/0777.xls"
sheet1 = book.worksheet 0
store = sheet1.row(0)[0][6..8]
row = sheet1.row(6)
printername = row[4]
printys = Printers.new.hashy(sheet1, store)

RSpec.describe CommonStuff, "#mod_name" do
  context "when sent printer name" do
    it "alter name if SIM or RT is found" do
      sim_row = sheet1.row(7)
      sim_printername = sim_row[4]
      new_name = mod_name(sim_printername, store)
      expect(new_name).to eq "0777SIM23"
    end
  end
end

RSpec.describe CommonStuff, "#fill_hash" do
  context "when sent configuration information" do
    it "returns the data in a hash" do
      cur_conf = fill_hash "lib/test_data/0777.xls", "On", "On"
      expect(cur_conf[:auto_mater]).to eq "On"
      expect(cur_conf[:batchy]).to eq "On"
      expect(cur_conf[:work_dir]).to eq "lib/test_data/0777.xls"
    end
  end
end

cur_conf = fill_hash "lib/test_data/0777.xls", "On", "On"

RSpec.describe Printers, "#hashy" do
  context "when sent a spreadsheet" do
    it "creates hash of printers to provision" do
      expect(printys["0777LAB1"]).to eq ["0777LAB1", "192.168.1.20", "HP LaserJet IV", "777 Test Printer Lab"]
    end
  end
end

RSpec.describe Printers, "#printer" do
  context "when sent a row of printer data" do
    it "creates array of printer data" do
      tester = Printers.new.printer(row, printername, store)
      expect(tester[1]).to eq "192.168.1.21"
    end
  end
end

RSpec.describe Printers, "#provision" do
  context "when sent a list of printers to provision" do
    it "displays lpadmin command to add each printer" do
      test_page = Printers.new.provision(printys, store)
      test_page = test_page["0777LAB1"]
      test_page = "lpadmin -p " + test_page[0] + " -L \"" + test_page[3] + "\" -D \"" + test_page[2] + "\" -E -v socket://" + test_page[1] + ":9100 -m raw"
      expect(test_page).to eq 'lpadmin -p 0777LAB1 -L "777 Test Printer Lab" -D "HP LaserJet IV" -E -v socket://192.168.1.20:9100 -m raw'
    end
  end
end

RSpec.describe Printers, "#show_printers" do
  context "when sent a list of printers to provision" do
    it "displays each printer that can be added in a nice format" do
      show_off = Printers.new.show_printers(printys, store)
      show_off = show_off["0777LAB2"]
      show_off = "Name: " + show_off[0] + " " + "Type: " + show_off[2] + " " + "IP: " + show_off[1] + " " + "Desc: " + show_off[3]
      expect(show_off).to eq 'Name: 0777LAB2 Type: Zebra Labeler IP: 192.168.1.21 Desc: 777 Test Printer Lab'
    end
  end
end

RSpec.describe Menu, "#batch" do
  context "when sent a spreadsheet" do
    it "gives the values for printers" do
      batch = Batch.new.process(cur_conf)
      expect(batch["0777LAB2"]).to eq ["0777LAB2", "192.168.1.21", "Zebra Labeler", "777 Test Printer Lab"]
    end
  end
end

RSpec.describe CommonStuff, "#bars" do
  context "when asked for top bar" do
    it "puts the top bar" do
      toppy = bar_top
      expect(toppy).to eq "__________________________________ Printsly __________________________________"
    end
  end
  context "when asked for lower bar" do
    it "puts the lower bar" do
      lowly = bar_low
      expect(lowly).to eq "------------------------------------------------------------------------------"
    end
  end
end

RSpec.describe CommonStuff, "#prov_text" do
  context "when asked for provisioning text" do
    it "puts the provisioning greeting including store number" do
      provo = prov_text(store)
      expect(provo).to eq "This is what I am planning on provisioning for store 777:"
    end
  end
end

RSpec.describe CommonStuff, "#printer_puts" do
  context "when sent array of printer data" do
    it "puts the information about the printer" do
      prints_albert = Printers.new.printer(row, printername, store)
      prints_albert = printer_puts(prints_albert)
      expect(prints_albert).to eq "\e[0;33;49mName: \e[0m0777LAB2 \e[0;33;49mType: \e[0mZebra Labeler \e[0;33;49mIP: \e[0m192.168.1.21 \e[0;33;49mDesc: \e[0m777 Test Printer Lab"
    end
  end
end
