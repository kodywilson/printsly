require 'printsly'

RSpec.describe Printers, "#build" do
  context "when sent a spreadsheet" do
    it "gives the lpadmin command" do
      printys = Printers.new.build("lib/test_data/0777.xls")
      printys.each do | printername, printerdata |
        printerdata[0] = "0" + store + printerdata[0] if printerdata[0].include?('RT')
        printerdata[0] = "0" + store + printerdata[0] if printerdata[0].include?('SIM')
        @test_page = "lpadmin -p " + printerdata[0] + " -L \"" + printerdata[3] + "\" -D \"" + printerdata[2] + "\" -E -v socket://" + printerdata[1] + ":9100 -m raw"
      end
      expect(@test_page).to eq 'lpadmin -p 0777LAB2 -L "777 Test Printer Lab" -D "Zebra Labeler" -E -v socket://192.168.1.21:9100 -m raw'
    end
  end
end

RSpec.describe Menu, "#batch" do
  context "when sent a spreadsheet" do
    it "gives the values for printers" do
      cur_conf = Hash.new
      cur_conf[:work_dir]   = "lib/test_data/0777.xls"
      cur_conf[:batchy]     = "On"
      cur_conf[:auto_mater] = "On"
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
